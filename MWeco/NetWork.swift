//
//  NetWork.swift
//  MWeco
//
//  Created by Monzy on 15/11/19.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit
import Alamofire

class NetWork {
    
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
    
    class func revokeOauth(onSuccess: Void -> Void) {
        guard let access_Token = SaveData.get(withKey: .ACCESS_TOKEN) else {
            return
        }
        Alamofire.request(.POST, BaseURL.kRevokeOauthURL, parameters: ["access_token": access_Token]).responseJSON {
            response in
            let json = JSON(response.result.value ?? [])
            for (key, value) in json {
                print("\(key): \(value.stringValue)")
                switch key {
                case "error":
                    return
                case "result":
                    print("revokeOauth result: \(value.boolValue)")
                    onSuccess()
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
    
    
    // Mark getStatuses
    class func getPublicTimeline(onSuccess: [Status] -> Void, onFailure: Void -> Void) {
        guard let access_Token = SaveData.get(withKey: .ACCESS_TOKEN) else {
            onFailure()
            return
        }
        
        Alamofire.request(.GET, BaseURL.kPublicTimeLine, parameters: ["access_token": access_Token, "count": 50, "page": 1]).responseJSON {
            response in
            let json = JSON(response.result.value ?? [])
            let statuses = json["statuses"]
            var publicStatuses = [Status]()
            for tmp in statuses {
                let statusJSON = tmp.1
                let status = Status(withJSON: statusJSON)
                publicStatuses.append(status)
            }
            onSuccess(publicStatuses)
        }
    }
    
    // Mark getFriendtimeline
    class func getFriendTimeline(onSuccess: [Status] -> Void, onFailure: Void -> Void) {
        guard let access_Token = SaveData.get(withKey: .ACCESS_TOKEN) else {
            onFailure()
            return
        }
        
        Alamofire.request(.GET, BaseURL.kFriendTimeLine, parameters: ["access_token": access_Token, "count": Constants.InitStatusesAmount, "page": 1]).responseJSON {
            response in
            let json = JSON(response.result.value ?? [])
            
            if let error = response.result.error {
                print("error: \(error)")
            } else {
                if json["error"].string != nil {
                    print("error: \(json)")
                    onFailure()
                } else {
                    //print(json)
                }
            }
            let statuses = json["statuses"]
            var publicStatuses = [Status]()
            for tmp in statuses {
                let statusJSON = tmp.1
                let status = Status(withJSON: statusJSON)
                publicStatuses.append(status)
            }
            onSuccess(publicStatuses)
        }
    }
    
    // Mark upload a text status
    class func uploadTextStatus(text: String) {
        guard let access_Token = SaveData.get(withKey: .ACCESS_TOKEN) else {return}
        Alamofire.request(.POST, BaseURL.kTextStatus, parameters: ["access_token": access_Token, "status": text, ]).responseJSON {
            response in
            let json = JSON(response.result.value ?? [])
            
            if let error = json["error"].string {
                print("error: \(error)")
            } else {
                print("success: \n\(json)")
            }
        }
    }
}
