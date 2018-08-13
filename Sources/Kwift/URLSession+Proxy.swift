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
