//
//  BaseURL.swift
//  MWeco
//
//  Created by Monzy on 15/11/19.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

struct BaseURL {
    static let kAppKey = "3595518900"
    static let kAppSecret = "3c09c0219f74efa24016a67b0f5ce08c"
    static let kRedirectURL = "https://api.weibo.com/oauth2/default.html"
    
    static let kAccessToken = "access_token"
    static let kUid = "uid"
    
    static let kOauthURL = "https://api.weibo.com/oauth2/authorize?client_id=\(BaseURL.kAppKey)&redirect_uri=\(BaseURL.kRedirectURL)&display=mobile&response_type=code"
    static let kRevokeOauthURL = "https://api.weibo.com/oauth2/revokeoauth2"
    static let kGetOauthInfo = "https://api.weibo.com/oauth2/get_token_info"
    static let kGetAccessToken = "https://api.weibo.com/oauth2/access_token"
    
    
    static let kPublicTimeLine = "https://api.weibo.com/2/statuses/public_timeline.json"
    static let kFriendTimeLine = "https://api.weibo.com/2/statuses/friends_timeline.json"
    
    static let kBaseURL = "https://api.weibo.com/2/"
    static let kStatusesPath = "statuses/friends_timeline.json"
    static let kFriendships = "friendships/friends.json"
    static let kTextStatus = "statuses/update.json"
    static let kImageStatus = "https://api.weibo.com/2/statuses/upload.json"
    static let kCommentCreate = "comments/create.json"
    static let kRepostStatus = "statuses/repost.json"
    static let kCommentReplay = "comments/reply.json"
    static let kCommentsToMe = "comments/to_me.json"
    static let kMentionStatuses = "statuses/mentions.json"
    static let kMentionComments = "comments/mentions.json"
    static let kCommentsForStatus = "comments/show.json"
}