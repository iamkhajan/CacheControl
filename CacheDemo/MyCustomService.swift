//  CacheDemo
//
//  Created by khajan pandey on 8/1/18.
//  Copyright © 2018 khajan pandey. All rights reserved.
//

import Foundation
import Alamofire

class MyCustomService : SessionDelegate {
    var urlCache: URLCache!
    var sessionManager : SessionManager!
    static let shared = MyCustomService()
    
    //The manager with the cache policy
    public let manager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .useProtocolCachePolicy
        configuration.timeoutIntervalForRequest = 35
        
        return Alamofire.SessionManager(configuration: configuration)
    }()
    
    override init() {
        let delegate: Alamofire.SessionDelegate = manager.delegate
        //Overriding delegate to add headers
        delegate.dataTaskWillCacheResponseWithCompletion = { session, datatask, cachedResponse, completion in
            let response = cachedResponse.response  as! HTTPURLResponse
            var headers = response.allHeaderFields as! [String: String]
            print(headers.keys.contains("Cache-Control"))
            headers["Cache-Control"] = "max-age=60"
            let modifiedResponse = HTTPURLResponse(
                url: response.url!,
                statusCode: response.statusCode,
                httpVersion: "HTTP/1.1",
                headerFields: headers)
            
            let modifiedCachedResponse = CachedURLResponse(
                response: modifiedResponse!,
                data: cachedResponse.data,
                userInfo: cachedResponse.userInfo,
                storagePolicy: cachedResponse.storagePolicy)
            completion(modifiedCachedResponse)
        }
    }
    
    
    func getSessionManager() -> SessionManager  {
        
        urlCache = {
            let capacity = 50 * 1024 * 1024 // MBs
            let urlCache = URLCache(memoryCapacity: capacity, diskCapacity: capacity, diskPath: nil)
            
            return urlCache
        }()
        sessionManager = {
            let configuration = URLSessionConfiguration.default
            configuration.requestCachePolicy = .useProtocolCachePolicy
            configuration.timeoutIntervalForRequest = 35
            configuration.requestCachePolicy = .returnCacheDataElseLoad
            configuration.urlCache = urlCache
            return Alamofire.SessionManager(configuration: configuration)
        }()
        
        return sessionManager
    }
}
