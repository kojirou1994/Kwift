import Foundation

extension JSONDecoder {
    
    @inlinable
    public func decode<T>(_ type: T.Type, from json: [String: Any]) throws -> T where T : Decodable {
        let data = try JSONSerialization.data(withJSONObject: json, options: [])
        return try decode(T.self, from: data)
    }
    
}
