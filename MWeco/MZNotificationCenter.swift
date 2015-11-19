//
//  MZNotificationCenter.swift
//  MWeco
//
//  Created by Monzy on 15/11/19.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

struct NotificationNames {
    static let ExpireTimeGot = "ExpireTimeGot"
    static let AccessTokenGot = "AccessTokenGot"
}

class MZNotificationCenter: NSObject {
    static var instance: MZNotificationCenter?
    class func getInstance() -> MZNotificationCenter {
        if instance == nil {
            instance = MZNotificationCenter()
        }
        return MZNotificationCenter.instance!
    }
    
    var expireTime: Int?
    
    private override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setExpireTime:", name: NotificationNames.ExpireTimeGot, object: nil)
    }
    
    func setExpireTime(notification: NSNotification) {
        let eTime = notification.userInfo!["expire_in"] as! Int
        self.expireTime = eTime
        print("[expire_time]: \(self.expireTime!)")
    }
    
    
}
