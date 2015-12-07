//
//  Constants.swift
//  AutoLayoutByCode
//
//  Created by Monzy on 15/11/26.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit


let FONT_SCREENNAME = UIFont(name: "Avenir-Light", size: 18)
let FONT_TEXT = UIFont(name: "Avenir-Light", size: 15)
let FONT_RETWEETSCREENNAME = UIFont(name: "Avenir-Light", size: 18)
let FONT_RETWEETTEXT = UIFont(name: "Avenir-Light", size: 15)

enum TimeLineType {
    case FriendTimeLine
    case SelfTimeLine
}

class Constants {
    static let InitStatusesAmount = 25
    static let userInfoStatuses = 20
    static let newStatusPlaceholder = "分享新鲜事..."
}

class StoryboardNames {
    static let userInfoCell = "UserInfoCell"
    static let commentUserCell = "CommentUserCell"
}

//Segues
class Segues {
    static let StatusMenu = "StatusMenuSegue"
    static let NewStatus = "NewStatusSegue"
    static let Return = "ReturnSegue"
    static let Repost = "RepostSegue"
    static let Comment = "CommentSegue"
    static let following = "FollowingListSegue"
    static let follower = "FollowerListSegue"
    static let detailStatus = "DetailStatusSegue"
}


//imagenames
class ImageNames {
    static let attitude_unactive = "upvote-unactive"
    static let attitude_active = "upvote-active"
    
    static let repost_unactive = "repost-unactive"
    static let repost_active = "repost-active"
    
    static let comment_unactive = "comment-unactive"
    static let comment_active = "comment-active"
    
    static let addButton = "addButton"
    static let addIcon = "icon-add-no-circle"
    
    static let defaultAvatar = "guapi"
    static let tick_white = "tick_white"
}

// tabbar item image names 
class Tabbar {
    static let unselected = [
        "tabbar-home-unselected",
        "tabbar-msg-unselected",
        "middle",
        "tabbar-search-unselected",
        "tabbar-me-unselected",
    ]
    
    static let selected = [
        "tabbar-home-selected",
        "tabbar-msg-selected",
        "middle",
        "tabbar-search-selected",
        "tabbar-me-selected",
    ]
    
    enum TabbarState {
        case Selected
        case UnSelected
    }
    
    static func tabbarImage(withIndex index: Int, andState state: TabbarState) -> UIImage {
        switch state {
        case .Selected:
            print(selected[index])
            return UIImage(named: selected[index])!
        case .UnSelected:
            return UIImage(named: unselected[index])!
        }
    }
}

class ImageType {
    static let origin = "origin"
    static let large = "large"
    static let bmiddle = "bmiddle"
    static let thumbnail = "thumbnail"
}

class Colors {
    static let pictureBackgroundColor = UIColor.clearColor()
    static let retweetBackgroundColor = UIColor(hex6: 0xE6E6E6)
    static let userInfoFollowButton = UIColor(hex6: 0xCC66FF)
}

class ItemSize {
    static let DefaultSpace: CGFloat = 10
    static let InnerSpace: CGFloat = 8
    static let HalfSpace: CGFloat = 5
    static let AvatarHeight: CGFloat = 48
    static let ButtonHeight: CGFloat = 20
    static let imageSpacePercent: CGFloat = 1 / 60
}

/*
retweetTextContentLabel?.text = status.retweetText
retweetTextContentLabel?.font = UIFont(name: "Avenir-Light", size: 15)
*/