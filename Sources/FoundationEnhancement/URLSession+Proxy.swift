//
//  URLSession+Proxy.swift
//  Kwift
//
//  Created by Kojirou on 2018/7/15.
//
#if os(macOS)
import Foundation

extension URLSession {
    
    public enum ProxyType {
        case socks5
        case http
        case https
    }
    
    public static func environment(_ environment: [String : String]? = nil) -> URLSession {
        let environment = environment ?? ProcessInfo.processInfo.environment
        let conf = URLSessionConfiguration.default
        conf.connectionProxyDictionary = [:]
        
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
//            let username = url.user
//            let password = url.password
            switch (scheme, type) {
            case ("http", .http), ("https", .http):
                conf.connectionProxyDictionary?[kCFNetworkProxiesHTTPEnable] = true
                conf.connectionProxyDictionary?[kCFNetworkProxiesHTTPProxy] = host
                conf.connectionProxyDictionary?[kCFNetworkProxiesHTTPPort] = port
            case ("http", .https), ("https", .https):
                conf.connectionProxyDictionary?[kCFNetworkProxiesHTTPSEnable] = true
                conf.connectionProxyDictionary?[kCFNetworkProxiesHTTPSProxy] = host
                conf.connectionProxyDictionary?[kCFNetworkProxiesHTTPSPort] = port
            case ("socks5", _):
                conf.connectionProxyDictionary?[kCFNetworkProxiesSOCKSEnable] = true
                conf.connectionProxyDictionary?[kCFNetworkProxiesSOCKSProxy] = host
                conf.connectionProxyDictionary?[kCFNetworkProxiesSOCKSPort] = port
            default:
                break
            }
        }
        readProxy(environment["http_proxy"], type: .http)
        readProxy(environment["https_proxy"], type: .https)
        readProxy(environment["all_proxy"], type: .socks5)
        readProxy(environment["HTTP_PROXY"], type: .http)
        readProxy(environment["HTTPS_PROXY"], type: .https)
        readProxy(environment["ALL_PROXY"], type: .socks5)
        return .init(configuration: conf)
    }
    
    public convenience init(proxyType: ProxyType, host: String, port: Int) {
        
        let conf = URLSessionConfiguration.default
        switch proxyType {
        case .http:
            conf.connectionProxyDictionary = [
                kCFNetworkProxiesHTTPEnable: true,
                kCFNetworkProxiesHTTPProxy: host,
                kCFNetworkProxiesHTTPPort: port
            ]
        case .https:
            conf.connectionProxyDictionary = [
                kCFNetworkProxiesHTTPSEnable: true,
                kCFNetworkProxiesHTTPSProxy: host,
                kCFNetworkProxiesHTTPSPort: port
            ]
        case .socks5:
            conf.connectionProxyDictionary = [
                kCFNetworkProxiesSOCKSEnable: true,
                kCFNetworkProxiesSOCKSProxy: host,
                kCFNetworkProxiesSOCKSPort: port
            ]
        }
        
        self.init(configuration: conf)
    }
}
#endif
