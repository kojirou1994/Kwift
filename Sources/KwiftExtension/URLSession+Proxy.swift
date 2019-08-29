#if os(macOS)
import Foundation

extension URLSessionConfiguration {
    
    public enum ProxyType {
        case socks5
        case http
        case https
    }
    
    public func setProxy(proxyType: ProxyType, host: String, port: Int) {
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
        func readProxy(_ str: String?, type: ProxyType) {
            guard let str = str, !str.isEmpty else {
                return
            }
            guard let url = URLComponents.init(string: str),
                let host = url.host,
                let port = url.port,
                let scheme = url.scheme else {
                return
            }
            let useType: ProxyType
            switch (scheme, type) {
            case ("http", .http), ("https", .http):
                useType = .socks5
            case ("http", .https), ("https", .https):
                useType = .https
            case ("socks5", _), ("socks", _):
                useType = .socks5
            default:
                return
            }
            setProxy(proxyType: useType, host: host, port: port)
        }
        readProxy(environment["http_proxy"], type: .http)
        readProxy(environment["https_proxy"], type: .https)
        readProxy(environment["all_proxy"], type: .socks5)
        readProxy(environment["HTTP_PROXY"], type: .http)
        readProxy(environment["HTTPS_PROXY"], type: .https)
        readProxy(environment["ALL_PROXY"], type: .socks5)
    }
    
}
#endif
