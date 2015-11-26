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
    static let StartTouchImageView = "StartTouchImageView"
    static let EndTouchImageView = "EndTouchImageView"
}

class MyBounds: AnyObject {
    var bounds: CGRect
    init(bounds: CGRect) {
        self.bounds = bounds
    }
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
    var currentOnTouchImagePath: String?
    var currentOnTouchImageBounds: CGRect?
    var imageRatio: Double?
    
    private override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setImageviewToPreview:", name: NotificationNames.StartTouchImageView, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "removeCurrentTouchImage", name: NotificationNames.EndTouchImageView, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setExpireTime:", name: NotificationNames.ExpireTimeGot, object: nil)
    }
    
    func setExpireTime(notification: NSNotification) {
        let eTime = notification.userInfo!["expire_in"] as! Int
        self.expireTime = eTime
        print("[expire_time]: \(self.expireTime!)")
    }
    
    func setImageviewToPreview(notification: NSNotification) {
        let url = notification.userInfo!["url"] as! NSURL
        currentOnTouchImagePath = (PictureURL.generatePicturePath(withType: ImageType.bmiddle, andSrc: url.absoluteString))
        currentOnTouchImageBounds = (notification.userInfo!["MyBounds"] as! MyBounds).bounds
        imageRatio = (notification.userInfo!["ratio"] as! Double)
        print("url: \(currentOnTouchImagePath ?? "hehe")")
    }
    
    func removeCurrentTouchImage() {
        currentOnTouchImagePath = nil
        currentOnTouchImageBounds = nil
        imageRatio = nil
        print("currentOnTouchImagePath removed")
    }
    
}
