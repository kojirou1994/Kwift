import Foundation

public protocol LosslessDataConvertible {
    
    init(_ data: Data) throws
    
    var data: Data { get }
    
}
