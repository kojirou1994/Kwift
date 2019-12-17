import Foundation

extension JSONDecoder {
    
    @inline(__always)
    public func kwiftDecode<T>(from json: [String: Any]) throws -> T where T : Decodable {
        try autoreleasepool {
            try decode(T.self, from: JSONSerialization.data(withJSONObject: json, options: []))
        }
    }

    @inline(__always)
    public func kwiftDecode<T>(from data: Data) throws -> T where T: Decodable {
        try autoreleasepool {
            try decode(T.self, from: data)
        }
    }
    
}
