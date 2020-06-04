import Foundation

#if os(macOS)
extension URLSessionConfiguration {

  public func disableProxy() {
    if connectionProxyDictionary == nil {
      connectionProxyDictionary = .init()
    }
    connectionProxyDictionary?[kCFNetworkProxiesHTTPEnable] = false
    connectionProxyDictionary?[kCFNetworkProxiesHTTPSEnable] = false
    connectionProxyDictionary?[kCFNetworkProxiesSOCKSEnable] = false
  }

  public func set(proxyInfo: ProxyInfo, for proxyType: ProxyType? = nil) {
    if connectionProxyDictionary == nil {
      connectionProxyDictionary = .init()
    }
    switch proxyType ?? proxyInfo.type {
    case .http:
      connectionProxyDictionary?[kCFNetworkProxiesHTTPEnable] = true
      connectionProxyDictionary?[kCFNetworkProxiesHTTPProxy] = proxyInfo.host
      connectionProxyDictionary?[kCFNetworkProxiesHTTPPort] = proxyInfo.port
    case .https:
      connectionProxyDictionary?[kCFNetworkProxiesHTTPSEnable] = true
      connectionProxyDictionary?[kCFNetworkProxiesHTTPSProxy] = proxyInfo.host
      connectionProxyDictionary?[kCFNetworkProxiesHTTPSPort] = proxyInfo.port
    case .socks5:
      connectionProxyDictionary?[kCFNetworkProxiesSOCKSEnable] = true
      connectionProxyDictionary?[kCFNetworkProxiesSOCKSProxy] = proxyInfo.host
      connectionProxyDictionary?[kCFNetworkProxiesSOCKSPort] = proxyInfo.port
    }
  }

  public func setProxy(environment: [String : String] = ProcessInfo.processInfo.environment,
                       parseUppercaseKey: Bool = false) {
    let values = ProxyEnvironment(environment: environment, parseUppercaseKey: parseUppercaseKey)
    if let all = values.all {
      switch all.type {
      case .socks5:
        set(proxyInfo: all)
      default:
        set(proxyInfo: all, for: .http)
        set(proxyInfo: all, for: .https)
      }
    } else {
      values.http.map {set(proxyInfo: $0, for: $0.type == .socks5 ? .socks5 : .http)}
      values.https.map {set(proxyInfo: $0, for: $0.type == .socks5 ? .socks5 : .https)}
    }
  }

}
#endif

enum ProxyEnvironmentKey: String {
  case http = "http_proxy"
  case https = "https_proxy"
  case all = "all_proxy"
}

public enum ProxyType: String, Equatable, CaseIterable {
  case http
  case https
  case socks5
}

public struct ProxyInfo {

  public let type: ProxyType
  public let host: String
  public let port: Int

  public init(type: ProxyType, host: String, port: Int) {
    self.type = type
    self.host = host
    self.port = port
  }

  public init?(_ str: String) {
    guard let url = URLComponents(string: str),
      let host = url.host,
      let port = url.port,
      let scheme = url.scheme,
      let type = ProxyType(rawValue: scheme.lowercased()) else {
        return nil
    }

    self.type = type
    self.host = host
    self.port = port
  }
}

public struct ProxyEnvironment {
  public let http: ProxyInfo?
  public let https: ProxyInfo?
  public let all: ProxyInfo?

  public init(environment: [String: String],
              parseUppercaseKey: Bool) {

    func parse(key: ProxyEnvironmentKey) -> ProxyInfo? {
      if let value = environment[key.rawValue] {
        return ProxyInfo(value)
      } else if parseUppercaseKey,
        let value = environment[key.rawValue.uppercased()] {
        return ProxyInfo(value)
      }
      return nil
    }

    http = parse(key: .http)
    https = parse(key: .https)
    all = parse(key: .all)
  }
}
