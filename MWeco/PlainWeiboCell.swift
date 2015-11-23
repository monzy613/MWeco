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
    @IBOutlet var upvoteButton: SpringButton! {
        didSet {
            print("upvoteButton didSet")
            updateButtonState()
        }
    }
    @IBOutlet var repostButton: SpringButton!
    @IBOutlet var commentButton: SpringButton!
    
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
        sendFromLabel.text = status.source?.componentsSeparatedByString(">")[1].componentsSeparatedByString("<")[0]
        upvoteButton.setTitle("\(status.attitudes_count)", forState: .Normal)
        commentButton.setTitle("\(status.comments_count)", forState: .Normal)
        repostButton.setTitle("\(status.reposts_count)", forState: .Normal)
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
