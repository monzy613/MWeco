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
    
    class func getOauthInfo() {
        guard let access_Token = SaveData.get(withKey: .ACCESS_TOKEN) else {
            return
        }
        
        /*
        {
        "uid": 1073880650,
        "appkey": 1352222456,
        "scope": null,
        "create_at": 1352267591,
        "expire_in": 157679471
        }
        */
        Alamofire.request(.POST, BaseURL.kGetOauthInfo, parameters: ["access_token": access_Token]).responseJSON {
            response in
            let json = JSON(response.result.value ?? [])
            if json["error"].string != nil {
                print("error: \(json)")
            } else {
                //print(json)
            }
            for (key, value) in json {
                print("\(key): \(value.stringValue)")
                switch key {
                case "expire_in":
                    NSNotificationCenter.defaultCenter().postNotificationName(NotificationNames.ExpireTimeGot, object: nil, userInfo: ["expire_in": value.intValue])
                case "uid":
                    let uid = NSNumber(longLong: value.int64Value)
                    print("uid: \(uid)")
                    SaveData.set(value: uid, withKey: DataKeys.UID)
                default:
                    break
                }
            }
        }
    }
    
    // Mark getUserInfo
    class func getUserInfo(onSuccess: JSON -> Void, onFailure: Void -> Void) {
        guard let access_Token = SaveData.get(withKey: .ACCESS_TOKEN) else {
            onFailure()
            return
        }
        
        let uid = SaveData.get(withKey: .UID) ?? 0
        
        Alamofire.request(.GET, BaseURL.userInfo, parameters: ["access_token": access_Token, "uid": uid!]).responseJSON {
            response in
            let json = JSON(response.result.value ?? [])
            if let error = json["error"].string {
                print("error: \(error)")
                return
            } else {
                print("getUserInfo success")
            }
            onSuccess(json)
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
    
    class func getTimeLine(type: TimeLineType, since_id: Int64, max_id: Int64, onSuccess: [Status] -> Void, onFailure: Void -> Void) {
        guard let access_Token = SaveData.get(withKey: .ACCESS_TOKEN) else {
            onFailure()
            return
        }
        var baseURL = ""
        var amount = 0
        switch type {
        case .FriendTimeLine:
            baseURL = BaseURL.kFriendTimeLine
            amount = Constants.InitStatusesAmount
        case .SelfTimeLine:
            baseURL = BaseURL.selfTimeLine
            amount = Constants.userInfoStatuses
        }
        
        Alamofire.request(.GET, baseURL, parameters: ["access_token": access_Token, "count": amount, "page": 1, "since_id": NSNumber(longLong: since_id), "max_id": NSNumber(longLong: max_id)]).responseJSON {
            response in
            let json = JSON(response.result.value ?? [])
            
            if let error = json["error"].string {
                print("error: \(error)")
                onFailure()
                return
            } else {
                print("getTimeLine success")
            }
            let statusesJSON = json["statuses"]
            var tmpStatuses = [Status]()
            for tmp in statusesJSON {
                let sJSON = tmp.1
                tmpStatuses.append(Status(withJSON: sJSON))
            }
            onSuccess(tmpStatuses)
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
    
    // Mark repost
    class func repost(originStatusID id: Int64, withText text: String) {
        guard let access_Token = SaveData.get(withKey: .ACCESS_TOKEN) else {return}
        Alamofire.request(.POST, BaseURL.repost, parameters: ["access_token": access_Token, "id": NSNumber(longLong: id), "status": text]).responseJSON {
            response in
            let json = JSON(response.result.value ?? [])
            
            if let error = json["error"].string {
                print("error: \(error)")
            } else {
                print("success: \n\(json)")
            }
        }
    }
    
    // Mark attitude
    class func attitude(statusId: String) {
        guard let access_Token = SaveData.get(withKey: .ACCESS_TOKEN) else {return}
        Alamofire.request(.POST, BaseURL.attitude, parameters: ["access_token": access_Token, "attitude": "simle", "id": statusId]).responseJSON {
            response in
            let json = JSON(response.result.value ?? [])
            
            if let error = json["error"].string {
                print("error: \(error)")
            } else {
                print("success: \n\(json)")
            }
        }
    }
    // Mark unattitude
    class func destroyAttitude(statusId: String) {
        guard let access_Token = SaveData.get(withKey: .ACCESS_TOKEN) else {return}
        Alamofire.request(.POST, BaseURL.destroyAttitude, parameters: ["access_token": access_Token, "attitude": "simle", "id": statusId]).responseJSON {
            response in
            let json = JSON(response.result.value ?? [])
            
            if let error = json["error"].string {
                print("error: \(error)")
            } else {
                print("success: \n\(json)")
            }
        }
    }
    
    // Mark get followings
    class func getFriends(ofType type: UserListType) {
        guard let access_token = SaveData.get(withKey: .ACCESS_TOKEN), let uid = SaveData.get(withKey: .UID) else {return}
        let url = ((type == UserListType.Following) ?BaseURL.followings:BaseURL.followers)
        Alamofire.request(.GET, url, parameters: ["access_token": access_token, "uid": uid]).responseJSON {
            response in
            let json = JSON(response.result.value ?? [])
            if type == .FollowMe {
                print("--------------------\n\(json)\n----------------------------")
            }
            if let error = json["error"].string {
                print("error: \(error)")
            } else {
                let users = json["users"]
                for tmp in users {
                    let user = tmp.1
                    switch type {
                    case .Following:
                        followings.append(Blogger(withJSON: user))
                    case .FollowMe:
                        followers.append(Blogger(withJSON: user))
                    }
                }
            }
        }
    }
    
    // Mark getFollowerIDs
    class func getFollowerIDs() {
        guard let access_token = SaveData.get(withKey: .ACCESS_TOKEN), let uid = SaveData.get(withKey: .UID) else {return}
        
        Alamofire.request(.GET, BaseURL.followerIDs, parameters: ["access_token": access_token, "uid": uid]).responseJSON {
            response in
            let json = JSON(response.result.value ?? [])
            print(json)
        }
    }
}
