//
//  NetWork.swift
//  MWeco
//
//  Created by Monzy on 15/11/19.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit
import Alamofire

class NetWork: NSObject {
    
    // Mark getAccess_Token
    class func getAccess_Token(code: String) {
        let redirect_uri = BaseURL.kRedirectURL
        Alamofire.request(.POST, BaseURL.kGetAccessToken, parameters: ["client_id": BaseURL.kAppKey, "client_secret": BaseURL.kAppSecret, "grant_type": "authorization_code", "code": code, "redirect_uri": redirect_uri]).responseJSON {
            response in
            let json = JSON(response.result.value ?? [])
            for (key, value) in json {
                print("\(key): \(value.stringValue)")
                switch key {
                    case "access_token":
                    SaveData.set(value: value.stringValue, withKey: .ACCESS_TOKEN)
                    case "uid":
                    SaveData.set(value: value.stringValue, withKey: .UID)
                default:
                    break
                }
            }
        }
    }
    
    class func revokeOauth() {
        guard let access_Token = SaveData.get(withKey: .ACCESS_TOKEN) else {
            return
        }
        Alamofire.request(.POST, BaseURL.kRevokeOauthURL, parameters: ["access_token": access_Token]).responseJSON {
            response in
            let json = JSON(response.result.value ?? [])
            for (key, value) in json {
                print("\(key): \(value.stringValue)")
                switch key {
                case "result":
                    print("revokeOauth result: \(value.boolValue)")
                default:
                    break
                }
            }
        }
    }
    
    class func getTokenExpireTime(){
        guard let access_Token = SaveData.get(withKey: .ACCESS_TOKEN) else {
            return
        }
        
        Alamofire.request(.POST, BaseURL.kGetOauthInfo, parameters: ["access_token": access_Token]).responseJSON {
            response in
            let json = JSON(response.result.value ?? [])
            for (key, value) in json {
                print("\(key): \(value.stringValue)")
                switch key {
                case "expire_in":
                    NSNotificationCenter.defaultCenter().postNotificationName(NotificationNames.ExpireTimeGot, object: nil, userInfo: ["expire_in": value.intValue])
                default:
                    break
                }
            }
        }
    }
}
