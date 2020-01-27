import Foundation

public struct StdError: Error, CustomStringConvertible, Equatable, Hashable {
    public let rawValue: Int32
    public static var current: Self {
        .init(errno)
    }
    public init(_ rawValue: Int32) {
        self.rawValue = rawValue
    }

    public var description: String {
        String(cString: strerror(rawValue))
    }
}
