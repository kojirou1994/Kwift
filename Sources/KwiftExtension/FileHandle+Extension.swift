import Foundation

extension FileHandle {
    @inlinable
    public func kwiftWrite<T: DataProtocol>(contentsOf data: T) {
        for region in data.regions {
            region.withUnsafeBytes { (bytes) in
                if let baseAddress = bytes.baseAddress, bytes.count > 0 {
                    let d = Data(bytesNoCopy: .init(mutating: baseAddress), count: bytes.count, deallocator: .none)
                    self.write(d)
                }
            }
        }
    }
}
