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

class SaveData: NSObject {
    private static let userDefaults = NSUserDefaults.standardUserDefaults()
    
    // Mark setter
    class func set(value value: AnyObject, withKey key: DataKeys) {
        SaveData.userDefaults.setValue(value, forKey: key.rawValue)
    }
    
    // Mark getter
    class func get(withKey key: DataKeys) -> AnyObject? {
        return userDefaults.objectForKey(key.rawValue)
    }
    
}
