//
//  UserInfoCell.swift
//  MWeco
//
//  Created by Monzy on 15/11/30.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

class UserInfoCell: UITableViewCell {
    
    // data
    var userInfo: Blogger!
    
    //outlets
    @IBOutlet var avatarImageView: SpringImageView! {
        didSet {
            avatarImageView.clipsToBounds = true
            avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        }
    }
    @IBOutlet var screenNameLabel: UILabel!
    @IBOutlet var genderLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var backgroundImageView: SpringImageView! {
        didSet {
            backgroundImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var statusAmountLabel: UILabel!
    @IBOutlet weak var followingAmountLabel: UILabel!
    @IBOutlet weak var followerAmountLabel: UILabel!
    
    
    @IBOutlet var currentStatusButton: SpringButton!
    @IBOutlet var originalStatusButton: SpringButton!
    @IBOutlet var albumButton: SpringButton!
    @IBOutlet var favorButton: SpringButton!
    
    
    func configure(withUserInfo userInfo: Blogger) {
        self.selectionStyle = .None
        statusAmountLabel.text = "\(userInfo.statuses_count)"
        followingAmountLabel.text = "\(userInfo.friends_count)"
        followerAmountLabel.text = "\(userInfo.followers_count)"
        screenNameLabel.text = userInfo.screen_name ?? "screenName"
        genderLabel.text = userInfo.gender ?? "未知"
        locationLabel.text = userInfo.location ?? "未知"
        avatarImageView.image = UIImage(data: NSData(contentsOfURL: userInfo.avatar_largeURL!)!)
        backgroundImageView.image = UIImage(data: NSData(contentsOfURL: userInfo.avatar_largeURL!)!)
    }
}
