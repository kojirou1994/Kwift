import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLSession {
    
    @discardableResult
    public func syncDataTask<T>(request: URLRequest, completionHandler: (Data?, URLResponse?, Error?) throws -> T) rethrows -> T {
        let cond = NSCondition()
        cond.lock()
        
        var resError: Error?
        var resData: Data?
        var response: URLResponse?
        var taskFinished = false
        let task = dataTask(with: request, completionHandler: { data, res, error in
            cond.lock()
            resData = data
            resError = error
            response = res
            taskFinished = true
            cond.signal()
            cond.unlock()
        })
        
        task.resume()
        while taskFinished == false {
            cond.wait()
        }
        cond.unlock()
        
        return try completionHandler(resData, response, resError)
    }
    
}

//MARK: - URLSession + Codable

private let decoder = JSONDecoder()

extension URLSession {
    
    public enum CodableTaskError: Error {
        case noData
        case network(URLError)
        case decoder(DecodingError)
    }
    
    private func convertHandler<T>(_ completionHandler: @escaping (Result<T, CodableTaskError>) -> Void)
        -> (Data?, URLResponse?, Error?) -> Void where T: Decodable {
            return { (data, response, error) in
                guard error == nil else {
                    completionHandler(.failure(.network(error as! URLError)))
                    return
                }
                guard let data = data else {
                    completionHandler(.failure(.noData))
                    return
                }
                do {
                    let result = try decoder.decode(T.self, from: data)
                    completionHandler(.success(result))
                } catch let error as DecodingError {
                    completionHandler(.failure(.decoder(error)))
                } catch {}
            }
    }
    
    public func codableTask<T>(with url: URL, completionHandler: @escaping (Result<T, CodableTaskError>) -> Void) -> URLSessionDataTask where T: Decodable {
        return dataTask(with: url, completionHandler: convertHandler(completionHandler))
    }
    
    public func codableTask<T>(with request: URLRequest, completionHandler: @escaping (Result<T, CodableTaskError>) -> Void) -> URLSessionDataTask where T: Decodable {
        return dataTask(with: request, completionHandler: convertHandler(completionHandler))
    }
    
    public func syncCodableTask<T>(with request: URLRequest) throws -> T where T: Decodable {
        return try syncDataTask(request: request) { (data, r, error) -> Result<T, CodableTaskError> in
            guard error == nil else {
                return .failure(.network(error as! URLError))
            }
            guard let data = data else {
                return .failure(.noData)
            }
            #if DEBUG
//            print(String(decoding: data, as: UTF8.self))
            #endif
            do {
                let result = try decoder.decode(T.self, from: data)
                return .success(result)
            }  catch let error as DecodingError {
                return .failure(.decoder(error))
            } catch { fatalError() }
        }.get()
    }
    
}
