//
//  URLSession+Sync.swift
//  Kwift
//
//  Created by Kojirou on 2018/10/6.
//

import Foundation

extension URLSession {
    
    public func sync(request: URLRequest, completionHandler: (Data?, URLResponse?, Error?) -> Void) {
        let cond = NSCondition()
        cond.lock()
        
        var resError: Error?
        var resData: Data?
        var response: URLResponse?
        var taskFinished = false
        let task = dataTask(with: request, completionHandler: { data, res, error in
            cond.lock()
            resData = data
            resError = error
            response = res
            taskFinished = true
            cond.signal()
            cond.unlock()
        })
        
        task.resume()
        while taskFinished == false {
            cond.wait()
        }
        cond.unlock()
        
        completionHandler(resData, response, resError)
    }
    
}
