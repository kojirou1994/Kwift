import Foundation

public protocol LosslessDataConvertible {

    associatedtype EncodedData: DataProtocol
    
    init<D: DataProtocol>(_ data: D) throws
    
    var data: EncodedData { get }
    
}
