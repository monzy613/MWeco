//
//  CommentUserCell.swift
//  MWeco
//
//  Created by 张逸 on 15/12/7.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

class CommentUserCell: UITableViewCell {
    var comment: Comment?
    
    // Mark outlets
    @IBOutlet weak var avatarImageView: AsyncImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    func configure(withComment _comment: Comment) {
        comment = _comment
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        avatarImageView.setURL(comment!.user.avatar_largeURL ?? comment!.user.avatarImageURL!, placeholderImage: UIImage(named: ImageNames.defaultAvatar))
        screenNameLabel.text = comment!.user.screen_name
        commentLabel.text = comment!.text
    }
    
}
