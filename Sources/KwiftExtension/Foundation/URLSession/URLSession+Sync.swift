import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLSession {

  public struct DataTaskResponse {
    public let data: Data
    public let response: URLResponse
  }

  public func resultTask(with request: URLRequest,
                         completion: @escaping (Result<DataTaskResponse, URLError>) -> Void)
    -> URLSessionDataTask {
    dataTask(with: request) { data, response, error in
      if let error = error as? URLError {
        completion(.failure(error))
      } else if let data = data, let response = response {
        completion(.success(.init(data: data, response: response)))
      } else {
        assertionFailure("This should not happen!")
        completion(.failure(URLError(.badServerResponse)))
      }
    }
  }

  public func syncResultTask(with request: URLRequest) -> Result<DataTaskResponse, URLError> {
    let condition = NSCondition()
    condition.lock()
    var result: Result<DataTaskResponse, URLError>?
    resultTask(with: request) { serverResult in
      condition.lock()
      result = serverResult
      condition.signal()
      condition.unlock()
    }.resume()

    while result == nil {
      condition.wait()
    }
    condition.unlock()

    return result!
  }

  @inlinable
  public func syncResultTask(with url: URL) -> Result<DataTaskResponse, URLError> {
    syncResultTask(with: .init(url: url))
  }
}
