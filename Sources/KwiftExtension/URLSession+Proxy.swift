#if os(macOS)
import Foundation

extension URLSessionConfiguration {

    public func disableProxy() {
        if connectionProxyDictionary == nil {
            connectionProxyDictionary = .init()
        }
        connectionProxyDictionary?.merge([
            kCFNetworkProxiesHTTPEnable: false,
            kCFNetworkProxiesHTTPSEnable: false,
            kCFNetworkProxiesSOCKSEnable: false
        ], uniquingKeysWith: {$1})
    }

    public func setProxy(proxyType: ProxyInfo.ProxyType, host: String, port: Int) {
        if connectionProxyDictionary == nil {
            connectionProxyDictionary = .init()
        }
        switch proxyType {
        case .http:
            connectionProxyDictionary?.merge([
                kCFNetworkProxiesHTTPEnable: true,
                kCFNetworkProxiesHTTPProxy: host,
                kCFNetworkProxiesHTTPPort: port
            ], uniquingKeysWith: {$1})
        case .https:
            connectionProxyDictionary?.merge([
                kCFNetworkProxiesHTTPSEnable: true,
                kCFNetworkProxiesHTTPSProxy: host,
                kCFNetworkProxiesHTTPSPort: port
            ], uniquingKeysWith: {$1})
        case .socks5:
            connectionProxyDictionary?.merge([
                kCFNetworkProxiesSOCKSEnable: true,
                kCFNetworkProxiesSOCKSProxy: host,
                kCFNetworkProxiesSOCKSPort: port
            ], uniquingKeysWith: {$1})
        }
    }
    
    public func setProxy(environment: [String : String]) {
        func readProxy(_ key: String) {
            guard let str = environment[key], !str.isEmpty else {
                return
            }
            guard let info = ProxyInfo.parse(str) else {
                return
            }
            setProxy(proxyType: info.type, host: info.host, port: info.port)
        }
        ProxyInfo.commonProxyKeys.forEach(readProxy(_:))
    }
    
}
#endif

public struct ProxyInfo {

    public static let commonProxyKeys = ["HTTP_PROXY", "http_proxy", "HTTPS_PROXY", "https_proxy", "ALL_PROXY", "all_proxy"]

    public let type: ProxyType
    public let host: String
    public let port: Int
    public let auth: (username: String, password: String)?

    public enum ProxyType: String {
        case http
        case https
        case socks5
    }

    public init(type: ProxyInfo.ProxyType, host: String, port: Int, auth: (username: String, password: String)?) {
        self.type = type
        self.host = host
        self.port = port
        self.auth = auth
    }

    public static func parse(_ str: String, defaultType: ProxyType? = .http) -> Self? {
        guard let url = URLComponents(string: str),
            let host = url.host,
            let port = url.port else {
                return nil
        }
        let type: ProxyType
        if let scheme = url.scheme?.lowercased() {
            if let v = ProxyType(rawValue: scheme) {
                type = v
            } else {
                return nil
            }
        } else if let v = defaultType {
            type = v
        } else {
            return nil
        }

        var auth: (username: String, password: String)?
        if let u = url.user, let p = url.password {
            auth = (u, p)
        }

        return .init(type: type, host: host, port: port, auth: auth)
    }
}
