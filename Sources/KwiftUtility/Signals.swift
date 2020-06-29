import Foundation

public enum Signals: RawRepresentable {

  public typealias RawValue = Int32

  case hup
  case int
  case quit
  case abrt
  case kill
  case alrm
  case term
  case pipe
  case user(Int32)

  public init?(rawValue: Int32) {
    switch rawValue {
    case SIGHUP:        self = .hup
    case SIGINT:        self = .int
    case SIGQUIT:       self = .quit
    case SIGABRT:       self = .abrt
    case SIGKILL:       self = .kill
    case SIGALRM:       self = .alrm
    case SIGTERM:       self = .term
    case SIGPIPE:       self = .pipe
    default:            self = .user(rawValue)
    }
  }

  public var rawValue: Int32 {
    switch self {
    case .hup:     return SIGHUP
    case .int:     return SIGINT
    case .quit:    return SIGQUIT
    case .abrt:    return SIGABRT
    case .kill:    return SIGKILL
    case .alrm:    return SIGALRM
    case .term:    return SIGTERM
    case .pipe:    return SIGPIPE
    case .user(let sig):    return sig
    }
  }

  public typealias SignalActionHandler = @convention(c)(Int32) -> Void

  public static func trap(signal: Self, action: @escaping SignalActionHandler) {
    #if canImport(Darwin)
    var signalAction = sigaction(__sigaction_u: unsafeBitCast(action, to: __sigaction_u.self), sa_mask: 0, sa_flags: 0)

    _ = withUnsafePointer(to: &signalAction) { actionPointer in

      sigaction(signal.rawValue, actionPointer, nil)
    }
    #elseif os(Linux)
    var sigAction = sigaction()

    sigAction.__sigaction_handler = unsafeBitCast(action, to: sigaction.__Unnamed_union___sigaction_handler.self)

    _ = sigaction(signal.rawValue, &sigAction, nil)
    #endif
  }

  public static func trap(signals: [(signal: Self, action: SignalActionHandler)]) {
    for sighandler in signals {
      Self.trap(signal: sighandler.signal, action: sighandler.action)
    }
  }

  public static func trap<C: Collection>(signals: C, action: @escaping SignalActionHandler) where C.Element == Self {
    for signal in signals {
      Signals.trap(signal: signal, action: action)
    }
  }

  public static func raise(signal: Self) {
    Foundation.raise(signal.rawValue)
  }

  public static func ignore(signal: Self) {
    Foundation.signal(signal.rawValue, SIG_IGN)
  }

  public static func restore(signal: Self) {
    Foundation.signal(signal.rawValue, SIG_DFL)
  }
}
