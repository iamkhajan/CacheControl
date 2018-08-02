//
//  ViewController.swift
//  CacheDemo
//
//  Created by khajan pandey on 7/31/18.
//  Copyright © 2018 khajan pandey. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var requiresUpdate: UILabel!
    @IBOutlet weak var appVersion: UILabel!
    
    var urlCache: URLCache!
     var manager: SessionManager!
    let urlString = "https://httpbin.org/response-headers"
//   let urlString = "https://staging.boschnext.com/dev/RB.Bnext.Configuration/v1.0/api/configuration/ios/version?currentVersion=2.4.0"
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
        
        self.appVersion.text = "Label"
        self.requiresUpdate.text = "Label"
        
        //show loading
        var indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator.center = view.center
        self.view.addSubview(indicator)
        self.view.bringSubview(toFront: indicator)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true        
        indicator.startAnimating()
        
        //dont show loading
        print("calling api now")
//        manager = MyCustomService.shared.getSessionManager()
        MyCustomService.shared.manager.request(urlString).responseJSON{response in
            DispatchQueue.main.async {
                 indicator.stopAnimating()
                if  (response == nil || response.result.value == nil) {
                    return
                }
//                 let swiftyJsonVar = JSON(response.result.value!)
//                let appVersion = swiftyJsonVar["latestVersion"].stringValue
//                 let forceUpdate = swiftyJsonVar["forceUpdate"].intValue
//                var requiresUpdate :String?
//                if forceUpdate == 0 {
//                    requiresUpdate = "false"
//                }
//                else{
//                    requiresUpdate = "true"
//                }
//               self.appVersion.text = appVersion
//               self.requiresUpdate.text = requiresUpdate
            }
            print(response)
        }
    }


}

