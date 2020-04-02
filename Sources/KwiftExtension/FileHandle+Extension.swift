import Foundation

extension FileHandle {
    
    #if canImport(Darwin) && swift(<5.2)
    @inlinable
    public func write<T: DataProtocol>(contentsOf data: T) throws {
        for region in data.regions {
            region.withUnsafeBytes { (bytes) in
                if let baseAddress = bytes.baseAddress, bytes.count > 0 {
                    self.write(Data(bytesNoCopy: .init(mutating: baseAddress), count: bytes.count, deallocator: .none))
                }
            }
        }
    }
    #endif

}
