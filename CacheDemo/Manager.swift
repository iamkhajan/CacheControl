//
//  Manager.swift
//  CacheDemo
//
//  Created by khajan pandey on 8/1/18.
//  Copyright © 2018 khajan pandey. All rights reserved.
//

import Foundation
import Alamofire

public class Manager: SessionDelegate {
    var manager: SessionManager?
    weak var sessionDelegate: SessionDelegate?
    override init() {
        super.init()
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = URLCache(memoryCapacity: 20 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: nil)
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.timeoutIntervalForRequest = 35
        self.manager = SessionManager(configuration: configuration)
        self.manager = Alamofire.SessionManager(configuration: configuration)
      //  self.manager?.delegate = self
    }
}
