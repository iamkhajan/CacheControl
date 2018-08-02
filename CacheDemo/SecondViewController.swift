//
//  SecondViewController.swift
//  CacheDemo
//
//  Created by khajan pandey on 7/31/18.
//  Copyright © 2018 khajan pandey. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SecondViewController: UIViewController {

    @IBOutlet weak var requiresUpdate: UILabel!
    @IBOutlet weak var appVersion: UILabel!
    
    var urlCache: URLCache!
    var manager: SessionManager!
    let urlString = "https://staging.boschnext.com/dev/RB.Bnext.Configuration/v1.0/api/configuration/ios/version?currentVersion=2.4.0"
    let requestTimeout: TimeInterval = 30
    var requests: [String: URLRequest] = [:]
    var timestamps: [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(ViewController.callNetworkWithCache), userInfo: nil, repeats: true)
        callNetworkWithCache()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @objc func callNetworkWithCache()  {
        var indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator.center = view.center
        self.view.addSubview(indicator)
        self.view.bringSubview(toFront: indicator)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        indicator.startAnimating()
        //        manager = MyCustomService.shared.getSessionManager()
        MyCustomService.shared.manager.request(urlString).responseJSON{response in
            DispatchQueue.main.async {
                indicator.stopAnimating()
                if  (response == nil || response.result.value == nil) {
                    return
                }
                let swiftyJsonVar = JSON(response.result.value!)
                let appVersion = swiftyJsonVar["latestVersion"].stringValue
                let forceUpdate = swiftyJsonVar["forceUpdate"].intValue
                var requiresUpdate :String?
                if forceUpdate == 0 {
                    requiresUpdate = "false"
                }
                else{
                    requiresUpdate = "true"
                }
                self.appVersion.text = appVersion
                self.requiresUpdate.text = requiresUpdate
            }
            print(response)
        }
    }
    
    
    @discardableResult
    func startRequest(
        cacheControl: String,
        cachePolicy: NSURLRequest.CachePolicy = .useProtocolCachePolicy,
        queue: DispatchQueue = DispatchQueue.main,
        completion: @escaping (URLRequest?, HTTPURLResponse?) -> Void)
        -> URLRequest
    {
        let urlRequest = self.urlRequest(cacheControl: cacheControl, cachePolicy: cachePolicy)
        let request = manager.request(urlRequest)
        
        request.response(
            queue: queue,
            completionHandler: { response in
                completion(response.request, response.response)
        }
        )
        
        return urlRequest
    }
    
    func urlRequest(cacheControl: String, cachePolicy: NSURLRequest.CachePolicy) -> URLRequest {
        let parameters = ["Cache-Control": cacheControl]
        let url = URL(string: urlString)!
        
        var urlRequest = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: requestTimeout)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        
        do {
            return try URLEncoding.default.encode(urlRequest, with: parameters)
        } catch {
            return urlRequest
        }
    }
    
    
    func primeCachedResponses() {
        let dispatchGroup = DispatchGroup()
        let serialQueue = DispatchQueue(label: "org.alamofire.cache-tests")
        for cacheControl in CacheControl.allValues {
            dispatchGroup.enter()
            
            let request = startRequest(
                cacheControl: cacheControl,
                queue: serialQueue,
                completion: { _, response in
                    let timestamp = response!.allHeaderFields["Date"] as! String
                    self.timestamps[cacheControl] = timestamp
                    
                    dispatchGroup.leave()
            }
            )
            
            requests[cacheControl] = request
        }
        
        // Wait for all requests to complete
        _ = dispatchGroup.wait(timeout: DispatchTime.now() + Double(Int64(30.0 * Float(NSEC_PER_SEC))) / Double(NSEC_PER_SEC))
        
        // Pause for 2 additional seconds to ensure all timestamps will be different
        dispatchGroup.enter()
        serialQueue.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2.0 * Float(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            dispatchGroup.leave()
        }
        
        // Wait for our 2 second pause to complete
        _ = dispatchGroup.wait(timeout: DispatchTime.now() + Double(Int64(10.0 * Float(NSEC_PER_SEC))) / Double(NSEC_PER_SEC))
    }

}
