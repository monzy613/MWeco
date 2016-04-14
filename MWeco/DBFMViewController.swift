//
//  DBFMViewController.swift
//  MWeco
//
//  Created by 张逸 on 16/4/9.
//  Copyright © 2016年 Monzy. All rights reserved.
//

import UIKit
import Alamofire

class DBFMViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        currentTabIndex = 3
        // Do any additional setup after loading the view.
        Alamofire.request(.POST, "http://www.douban.com/j/app/login", parameters: ["app_name": "radio_desktop_win", "version": 100, "email": "357272055@qq.com", "password": "aiakb48miao"]).responseJSON {
            response in
            let json = JSON(response.result.value ?? [])
            if json["error"].string != nil {
                print("error: \(json)")
            } else {
                print(json)
            }
            /*
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
            */
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
