import Foundation

#if !swift(>=5)

public enum Result<Success, Failure> where Failure : Error {

    case success(Success)

    case failure(Failure)

    public func get() throws -> Success {
        switch self {
        case .success(let v):
            return v
        case .failure(let e):
            throw e
        }
    }

}

//extension Result {
//
//    public static func != (lhs: Result<Success, Failure>, rhs: Result<Success, Failure>) -> Bool
//}
//
//extension Result : Equatable where Success : Equatable, Failure : Equatable {
//}
//
//extension Result : Hashable where Success : Hashable, Failure : Hashable {
//}


#endif
