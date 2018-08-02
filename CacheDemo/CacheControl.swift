//
//  CacheControl.swift
//  CacheDemo
//
//  Created by khajan pandey on 7/31/18.
//  Copyright © 2018 khajan pandey. All rights reserved.
//

import Foundation
struct CacheControl {
    static let publicControl = "public"
    static let privateControl = "private"
    static let maxAgeNonExpired = "max-age=3600"
    static let maxAgeExpired = "max-age=0"
    static let noCache = "no-cache"
    static let noStore = "no-store"
    
    static var allValues: [String] {
        return [
            CacheControl.publicControl,
            CacheControl.privateControl,
            CacheControl.maxAgeNonExpired,
            CacheControl.maxAgeExpired,
            CacheControl.noCache,
            CacheControl.noStore
        ]
    }
}
