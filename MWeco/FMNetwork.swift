//
//  Network.swift
//  M_fm
//
//  Created by 张逸 on 16/4/11.
//  Copyright © 2016年 MonzyZhang. All rights reserved.
//

import Foundation
import Alamofire
struct DBURL {
    static var getChannels: String {
        get {
            return "http://www.douban.com/j/app/radio/channels"
        }
    }

    static func getMusicWithChannel(channer_id: String) -> String {
        return "http://douban.fm/j/mine/playlist?channel=\(channer_id)"
    }
}