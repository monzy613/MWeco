//
//  SaveData.swift
//  MWeco
//
//  Created by Monzy on 15/11/19.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit


enum DataKeys: String {
    case ACCESS_TOKEN = "ACCESS_TOKEN"
    case UID = "UID"
}

class SaveData {
    private static let userDefaults = NSUserDefaults.standardUserDefaults()
    
    // Mark setter
    class func set(value value: AnyObject, withKey key: DataKeys) {
        userDefaults.setValue(value, forKey: key.rawValue)
    }
    
    // Mark getter
    class func get(withKey key: DataKeys) -> AnyObject? {
        return userDefaults.objectForKey(key.rawValue)
    }
    
    // Mark revokeOauth
    class func remove(withKey key: DataKeys) {
        if userDefaults.objectForKey(key.rawValue) != nil {
            userDefaults.removeObjectForKey(key.rawValue)
            print("\(key.rawValue) removed")
        }
    }
    
}
