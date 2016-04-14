//
//  DBChannel.swift
//  M_fm
//
//  Created by 张逸 on 16/4/11.
//  Copyright © 2016年 MonzyZhang. All rights reserved.
//

import UIKit


func == (lhs: DBChannel, rhs: DBChannel) -> Bool {
    return lhs.channel_id == rhs.channel_id
}

class DBChannel: AnyObject, Hashable, Equatable {
    var name_en: String = ""
    var name: String = ""
    var seq_id: Int = -1
    var channel_id: String = ""
    var hashValue: Int {
        get {
            return Int(channel_id) ?? 0
        }
    }

    init(withJSON json: JSON) {
        name_en = json["name_en"].string ?? ""
        name = json["name"].string ?? ""
        seq_id = json["seq_id"].int ?? -1
        channel_id = json["channel_id"].string ?? ""
    }
}
