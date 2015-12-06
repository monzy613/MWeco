//
//  UserInfoCell.swift
//  MWeco
//
//  Created by 张逸 on 15/12/4.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

class UserInfoCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: AsyncImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var follow_unfollowButton: UIButton!
    
    @IBAction func changeFollowState(sender: SpringButton) {
    }
    
    func configure(withUserInfo userInfo: Blogger) {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.clipsToBounds = true
        follow_unfollowButton.layer.cornerRadius = follow_unfollowButton.frame.height / 2
        
        if let avatarURL = userInfo.avatar_largeURL {
            avatarImageView.setURL(avatarURL, placeholderImage: UIImage(named: ImageNames.defaultAvatar))
        }
        
        screenNameLabel.text = userInfo.screen_name
        descriptionLabel.text = userInfo.myDescription
        
        if userInfo.following && userInfo.isFollowMe {
            follow_unfollowButton.setTitle("双向关注", forState: .Normal)
        } else if userInfo.following && !(userInfo.isFollowMe) {
            follow_unfollowButton.setTitle("已关注", forState: .Normal)
        } else if !(userInfo.following) && userInfo.isFollowMe {
            follow_unfollowButton.setTitle("加关注", forState: .Normal)
        }
    }
}
