import Foundation

public struct StderrOutputStream: TextOutputStream {
    public func write(_ string: String) {
        fputs(string, stderr)
    }
}

public struct StdoutOutputStream: TextOutputStream {
    public func write(_ string: String) {
        fputs(string, stdout)
    }
}

public struct StdOutputStream {
    public static var stderr = StderrOutputStream()

    public static var stdout = StdoutOutputStream()
}
