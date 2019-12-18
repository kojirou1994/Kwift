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

    @inline(__always)
    public func kwiftDecode<D, T>(from bytes: D) throws -> T where D: ContiguousBytes, T: Decodable {
        try bytes.withUnsafeBytes { (ptr) -> T in
            try kwiftDecode(from: Data(bytesNoCopy: UnsafeMutableRawPointer(mutating: ptr.baseAddress!), count: ptr.count, deallocator: .none))
        }
    }
    
}
