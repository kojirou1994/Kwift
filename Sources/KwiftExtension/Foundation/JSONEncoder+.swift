import Foundation

extension JSONEncoder {
    @inline(__always)
    public func kwiftEncode<T>(_ value: T) throws -> Data where T: Encodable {
        try autoreleasepool {
            try encode(value)
        }
    }
}
