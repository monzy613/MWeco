//
//  PlainWeiboCell.swift
//  MWeco
//
//  Created by Monzy on 15/11/20.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

class PlainWeiboCell: UITableViewCell {
    
    var status: Status?
    
    // Mark outlets
    @IBOutlet var avatarImageView: AsyncImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var sendFromLabel: UILabel!
    @IBOutlet var repostContentLabel: UILabel!
    @IBOutlet var upvoteButton: SpringButton! {
        didSet {
            updateButtonState()
        }
    }
    @IBOutlet var repostButton: SpringButton!
    @IBOutlet var commentButton: SpringButton!
    @IBOutlet var otherContentView: UIView!
    
    // Mark actions
    @IBAction func upvoteButtonPressed(sender: SpringButton) {
        sender.animation = "pop"
        sender.animate()
        var newState: Bool = (status?.liked)!
        newState = !newState
        status?.liked = newState
        updateButtonState()
    }
    
    @IBAction func repostButtonPressed(sender: SpringButton) {
        sender.animation = "pop"
        sender.animate()
    }
    
    @IBAction func commentButtonPressed(sender: SpringButton) {
        sender.animation = "pop"
        sender.animate()
    }
    
    func updateButtonState() {
        if status?.liked == true {
            upvoteButton?.setImage(UIImage(named: "upvote-active"), forState: .Normal)
        } else if status?.liked == false {
            upvoteButton?.setImage(UIImage(named: "upvote-unactive"), forState: .Normal)
        }
    }
    
    func configure(status: Status) {
        print("configure")
        self.status = nil
        self.status = status
        guard let blogger = status.blogger else {
            return
        }
        updateButtonState()
        nameLabel.text = blogger.screen_name ?? "NIL"
        contentLabel.text = status.text ?? "NIL"
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.clipsToBounds = true
        guard let url = blogger.avatarImageURL else {return}
        avatarImageView.setURL(url, placeholderImage: avatarImageView.image)
        // <a xxx>iPhone 6</a>
        
//        if let source = status.source {
//            let components1 = source.componentsSeparatedByString(">")
//            if components1.count >= 2 {
//                let components2 = components1[1].componentsSeparatedByString("<")
//                if components2.count >= 1 {
//                    sendFromLabel.text = components2[0]
//                } else {
//                    sendFromLabel.text = "新浪微博"
//                }
//            } else {
//                sendFromLabel.text = "新浪微博"
//            }
//        } else {
//            sendFromLabel.text = "新浪微博"
//        }
//        
        upvoteButton.setTitle("\(status.attitudes_count)", forState: .Normal)
        commentButton.setTitle("\(status.comments_count)", forState: .Normal)
        repostButton.setTitle("\(status.reposts_count)", forState: .Normal)
        
        if let retweeted_status = self.status?.retweeted_status {
            repostContentLabel.text = retweeted_status.text
            otherContentView.backgroundColor = UIColor(hex6: 0x66FFFF)
        } else {
            print("no repost")
            repostContentLabel.text = ""
            otherContentView.backgroundColor = UIColor.clearColor()
        }
    }
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}


func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}
