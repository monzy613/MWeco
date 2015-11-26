//
//  Weibo.swift
//  MWeco
//
//  Created by Monzy on 15/11/20.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

enum PIC_URLS: String {
    case Thumbnail = "thumbnail_pic"
    case Bmiddle = "bmiddle_pic"
    case Original = "original_pic"
}

class PictureURL {
    var thumbnailURL: NSURL
    var bmiddleURL: NSURL
    var largeURL: NSURL
    init(thumbnail: String, bmiddle: String, large: String) {
        self.thumbnailURL = NSURL(string: thumbnail) ?? NSURL()
        self.bmiddleURL = NSURL(string: bmiddle) ?? NSURL()
        self.largeURL = NSURL(string: large) ?? NSURL()
    }
    
    init(withThumbnail thumbnail: String) {
        let bmiddle = PictureURL.generatePicturePath(withType: "bmiddle", andSrc: thumbnail)
        let large = PictureURL.generatePicturePath(withType: "large", andSrc: thumbnail)
        self.thumbnailURL = NSURL(string: thumbnail) ?? NSURL()
        self.bmiddleURL = NSURL(string: bmiddle) ?? NSURL()
        self.largeURL = NSURL(string: large) ?? NSURL()
    }

    class func generatePicturePath(withType type: String, andSrc src: String) -> String {
        var path = ""
        var components = NSString(string: src).pathComponents
        if components.count >= 4 {
            path = "\(components[0])//\(components[1])/\(type)/\(components[3])"
        }
        return path
    }
    
}

class Blogger {
    
    init() {
    }
    
    init(withJSON json: JSON) {
        self.id = json["id"].string ?? "nil"
        self.name = json["name"].string ?? "nil"
        self.screen_name = json["screen_name"].string ?? self.name
        self.avatarImageURL = NSURL(string: json["profile_image_url"].stringValue)
        self.avatar_largeURL = NSURL(string: json["avatar_large"].string ?? (self.avatarImageURL?.path!)!)
        self.avatar_HDURL = NSURL(string: json["avatar_hd"].string ?? (self.avatarImageURL?.path!)!)
    }
    
    var id: String?
    var blogger_class: Int?
    var screen_name: String?
    var name: String?
    
    var province: Int?
    var city: Int?
    var location: String?
    var description: String?
    var blogURL: NSURL?
    var avatarImageURL: NSURL?
    var profileURL: NSURL?
    var domain: String?
    var weihao: String?
    var gender: String? // m-male, f-female
    var followers_count: Int = 0
    var bi_followers_count: Int = 0
    var friends_count: Int = 0
    var statuses_count: Int = 0
    var favourites_count: Int = 0
    var created_at: String?
    var allow_all_act_msg: Bool?
    var gen_enabled: Bool?
    var verified: Bool?
    var verified_reason: String?
    var remark: String?
    var recentOneStatus: Status?
    var allow_all_comment: Bool?
    var avatar_largeURL: NSURL?
    var avatar_HDURL: NSURL?
    var isFollowMe: Bool?
    var isOnline: Bool?
    var lang = "zh-cn" // "en", "zh-cn", "zh-tw"
}

class Status {
    
    init() {
    }
    
    init(withJSON json: JSON) {
        self.created_at = json["created_at"].string ?? "nil"
        self.id = json["id"].int64 ?? 0
        self.mid = json["mid"].int64 ?? 0
        self.idstr = "\(id)"
        self.text = json["text"].string ?? "nil"
        self.rawSource = json["source"].string ?? "<a>nil</a>"
        self.liked = json["liked"].bool ?? false
        self.truncated = json["truncated"].bool ?? false
        //json[PIC_URLS.Thumbnail.rawValue]
        //json[PIC_URLS.Bmiddle.rawValue]
        //json[PIC_URLS.Original.rawValue]
        self.blogger = Blogger(withJSON: json["user"])
        self.attitudes_count = json["attitudes_count"].int ?? 0
        self.comments_count = json["comments_count"].int ?? 0
        self.reposts_count = json["reposts_count"].int ?? 0
        if json["retweeted_status"] == JSON.null {
            hasRetweet = false
        } else {
            hasRetweet = true
            self.retweeted_status = Status(withJSON: json["retweeted_status"])
        }
        
        let picJSONArr = json["pic_urls"].array ?? []
        if picJSONArr.count > 0 {
            hasPictures = true
        }
        for picJson in picJSONArr {
            let picPath = picJson[PIC_URLS.Thumbnail.rawValue].string ?? "nilPath"
            pic_urls.append(PictureURL(withThumbnail: picPath))
            print("\(picPath)")
        }
    }
    
    var created_at: String?
    var id: Int64?
    var mid: Int64?
    var idstr: String?
    var text: String?
    var rawSource: String?
    var source: String {
        get {
            guard let rawValue = rawSource else {
                return "nil"
            }
//            print("rawSource: \(rawValue)")
            let item1 = rawValue.componentsSeparatedByString(">")
            if item1.count >= 2 {
                let item2 = item1[1].componentsSeparatedByString("<")
                if item2.count >= 1 {
                    return item2[0]
                } else {
                    return "nil"
                }
            } else {
                return "nil"
            }
        }
    }
    var liked: Bool?
    var truncated: Bool?
    var retweeted_status: Status?
    
    
    var attitudes_count: Int = 0
    var comments_count: Int = 0
    var reposts_count: Int = 0
    
    var pic_urls = [PictureURL]()
    var blogger: Blogger?
    
    
    var hasRetweet: Bool = false
    var hasPictures: Bool = false
}
