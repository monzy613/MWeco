//
//  StatusCell.swift
//  AutoLayoutByCode
//
//  Created by Monzy on 15/11/25.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

protocol StatusCellDelegate {
    func repost(withSender sender: AnyObject)
    func comment(withSender sender: AnyObject)
    func detailImage(withSender sender: AnyObject)
}

class StatusCell: UITableViewCell {
    
    
    var delegate: StatusCellDelegate?
    //data
    var status: Status!
    
    //self status
    var avatarImageView: AsyncImageView?
    var screenNameLabel: UILabel?
    var createAtLabel: UILabel?
    var sourceLabel: UILabel?
    var textContentLabel: UILabel?
    
    //pictureView
    var pictureView: UIView?
    
    //retweet status
    var retweetView: UIView?
    var retweetScreenNameLabel: UILabel?
    var retweetTextContentLabel: UILabel?
    var retweetRepostButton: UIButton?
    var retweetCommentButton: UIButton?
    var retweetAttitudeButton: UIButton?
    var retweetPictureView: UIView?
    
    //3 buttons
    var repostButton: SpringButton?
    var commentButton: SpringButton?
    var attitudeButton: SpringButton?
    
    
    init(withStatus status: Status, style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.status = status
        setUserInfo()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUserInfo() {
        
        //avatar constraints
        avatarImageView = AsyncImageView()
        avatarImageView?.userInteractionEnabled = true
        avatarImageView?.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView?.contentMode = .ScaleAspectFit
        guard let avatarURL = status.blogger!.avatar_largeURL else {return}
        avatarImageView?.setURL(avatarURL, placeholderImage: UIImage(named: "guapi"))
        avatarImageView?.layer.cornerRadius = ItemSize.AvatarHeight / 2
        avatarImageView?.clipsToBounds = true
        contentView.addSubview(avatarImageView!)
        contentView.addConstraint(NSLayoutConstraint(item: avatarImageView!, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 10))
        
        contentView.addConstraint(NSLayoutConstraint(item: avatarImageView!, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 10))
        contentView.addConstraint(NSLayoutConstraint(item: avatarImageView!, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: ItemSize.AvatarHeight))
        contentView.addConstraint(NSLayoutConstraint(item: avatarImageView!, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: ItemSize.AvatarHeight))
        
        //screenNameLabel constraints
        screenNameLabel = UILabel()
        screenNameLabel?.font = FONT_SCREENNAME
        screenNameLabel?.text = status.blogger?.screen_name
        screenNameLabel?.textAlignment = .Left
        screenNameLabel?.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(screenNameLabel!)
        contentView.addConstraints([
            NSLayoutConstraint(item: screenNameLabel!, attribute: .Top, relatedBy: .Equal, toItem: avatarImageView!, attribute: .Top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: screenNameLabel!, attribute: .Left, relatedBy: .Equal, toItem: avatarImageView!, attribute: .Right, multiplier: 1, constant: ItemSize.DefaultSpace),
            NSLayoutConstraint(item: screenNameLabel!, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .RightMargin, multiplier: 1, constant: ItemSize.DefaultSpace)
            ])
        
        //contentTextLabel constraints
        let contentText = status.text
        textContentLabel = UILabel()
        textContentLabel?.lineBreakMode = .ByCharWrapping
        textContentLabel?.numberOfLines = 0
        textContentLabel?.font = UIFont(name: "Avenir-Light", size: 15)
        textContentLabel?.text = contentText
        textContentLabel?.textAlignment = .Left
        textContentLabel?.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textContentLabel!)
        contentView.addConstraints([
            NSLayoutConstraint(item: textContentLabel!, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: ItemSize.DefaultSpace),
            NSLayoutConstraint(item: textContentLabel!, attribute: .Top, relatedBy: .Equal, toItem: avatarImageView!, attribute: .Bottom, multiplier: 1, constant: ItemSize.DefaultSpace),
            NSLayoutConstraint(item: textContentLabel!, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .RightMargin, multiplier: 1, constant: ItemSize.DefaultSpace)
            ])
        
        // [optional] picture(s)
        if status.hasPictures {
            let pictureViewWidth = UIScreen.mainScreen().bounds.width - 10 * 2
            let pictureSpace = pictureViewWidth * ItemSize.imageSpacePercent
            let pictureWidth = (pictureViewWidth - 4 * pictureSpace) / 3
            pictureView = UIView()
            pictureView?.backgroundColor = Colors.pictureBackgroundColor
            pictureView!.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(pictureView!)
            contentView.addConstraints([
                NSLayoutConstraint(item: pictureView!, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 10),
                NSLayoutConstraint(item: pictureView!, attribute: .Top, relatedBy: .Equal, toItem: textContentLabel!, attribute: .Bottom, multiplier: 1, constant: 10),
                NSLayoutConstraint(item: pictureView!, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: pictureViewWidth)
                ])
            switch status.pic_urls.count {
            case 1...3:
                contentView.addConstraint(NSLayoutConstraint(item: pictureView!, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: pictureSpace * 2 + pictureWidth))
            case 4...6:
                contentView.addConstraint(NSLayoutConstraint(item: pictureView!, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: pictureSpace * 3 + pictureWidth * 2))
            case 6...9:
                contentView.addConstraint(NSLayoutConstraint(item: pictureView!, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: pictureSpace * 4 + pictureWidth * 3))
            default:
                print("pictureNumber > 9")
            }
            for i in 0..<status.pic_urls.count {
                //0 1 2
                //3 4 5
                //6 7 8
                let row = CGFloat(i / 3)//0 1 2
                let column = CGFloat(i % 3)//0 1 2
                let imageView = AsyncImageView()
                imageView.rootCell = self
                imageView.index = i
                imageView.userInteractionEnabled = true
                imageView.contentMode = .ScaleAspectFill
                imageView.clipsToBounds = true
                imageView.setURL(status.pic_urls[i].thumbnailURL, placeholderImage: UIImage(named: "guapi"))
                imageView.translatesAutoresizingMaskIntoConstraints = false
                pictureView!.addSubview(imageView)
                pictureView?.addConstraints([
                    NSLayoutConstraint(item: imageView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: pictureWidth),
                    NSLayoutConstraint(item: imageView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: pictureWidth),
                    NSLayoutConstraint(item: imageView, attribute: .Left, relatedBy: .Equal, toItem: pictureView!, attribute: .Left, multiplier: 1, constant: (column + 1) * pictureSpace + column * pictureWidth),
                    NSLayoutConstraint(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: pictureView!, attribute: .Top, multiplier: 1, constant: (row + 1) * pictureSpace + row * pictureWidth)
                    ])
            }
        }
        
        // [optional] repost status
        /*
        //retweet status
        var retweetView: UIView?
        var retweetScreenNameLabel: UILabel?
        var retweetTextContentLabel: UILabel?
        var retweetRepostButton: UIButton?
        var retweetCommentButton: UIButton?
        var retweetAttitudeButton: UIButton?
        */
        if status.hasRetweet {
            retweetView = UIView()
            retweetScreenNameLabel = UILabel()
            retweetTextContentLabel = UILabel()
            retweetView?.addSubview(retweetScreenNameLabel!)
            retweetView?.addSubview(retweetTextContentLabel!)
            
            //retweetView
            let retweetViewWidth = UIScreen.mainScreen().bounds.width - 10 * 2
            let retweetTextContentLabelWidth = retweetViewWidth - 10 * 2
            retweetView?.backgroundColor = Colors.retweetBackgroundColor
            retweetView?.translatesAutoresizingMaskIntoConstraints = false
            let topView = (status.hasPictures == true ?pictureView!: textContentLabel!)
            contentView.addSubview(retweetView!)
            contentView.addConstraints([
                NSLayoutConstraint(item: retweetView!, attribute: .Top, relatedBy: .Equal, toItem: topView, attribute: .Bottom, multiplier: 1, constant: 10),
                NSLayoutConstraint(item: retweetView!, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 10),
                NSLayoutConstraint(item: retweetView!, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: retweetViewWidth)
                ])
            
            //retweetscreenName
            retweetScreenNameLabel?.text = status.retweeted_status?.blogger?.screen_name
            retweetScreenNameLabel?.font = FONT_RETWEETSCREENNAME
            retweetScreenNameLabel?.translatesAutoresizingMaskIntoConstraints = false
            retweetView?.addConstraints([
                NSLayoutConstraint(item: retweetScreenNameLabel!, attribute: .Left, relatedBy: .Equal, toItem: retweetView!, attribute: .Left, multiplier: 1, constant: 10),
                NSLayoutConstraint(item: retweetScreenNameLabel!, attribute: .Top, relatedBy: .Equal, toItem: retweetView!, attribute: .Top, multiplier: 1, constant: 10),
                NSLayoutConstraint(item: retweetScreenNameLabel!, attribute: .Right, relatedBy: .Equal, toItem: retweetView!, attribute: .Right, multiplier: 1, constant: 10),
                ])
            
            //contentText
            retweetTextContentLabel?.lineBreakMode = .ByCharWrapping
            retweetTextContentLabel?.numberOfLines = 0
            retweetTextContentLabel?.textAlignment = .Left
            retweetTextContentLabel?.text = status.retweeted_status?.text
            retweetTextContentLabel?.font = FONT_RETWEETTEXT
            retweetTextContentLabel?.translatesAutoresizingMaskIntoConstraints = false
            retweetView?.addConstraints([
                NSLayoutConstraint(item: retweetTextContentLabel!, attribute: .Top, relatedBy: .Equal, toItem: retweetScreenNameLabel!, attribute: .Bottom, multiplier: 1, constant: 10),
                NSLayoutConstraint(item: retweetTextContentLabel!, attribute: .Left, relatedBy: .Equal, toItem: retweetView!, attribute: .Left, multiplier: 1, constant: 10),
                NSLayoutConstraint(item: retweetTextContentLabel!, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: retweetTextContentLabelWidth)
                ])
            
            //retweetPictures
            if status.retweeted_status!.hasPictures {
                let rPictureViewWidth = retweetViewWidth - ItemSize.DefaultSpace * 2
                let rPictureSpace = rPictureViewWidth * ItemSize.imageSpacePercent
                let rPictureWidth = (rPictureViewWidth - 4 * rPictureSpace) / 3
                retweetPictureView = UIView()
                retweetPictureView?.backgroundColor = Colors.pictureBackgroundColor
                retweetPictureView?.translatesAutoresizingMaskIntoConstraints = false
                retweetView?.addSubview(retweetPictureView!)
                retweetView?.addConstraints([
                    NSLayoutConstraint(item: retweetPictureView!, attribute: .Left, relatedBy: .Equal, toItem: retweetView!, attribute: .Left, multiplier: 1, constant: ItemSize.DefaultSpace),
                    NSLayoutConstraint(item: retweetPictureView!, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: rPictureViewWidth),
                    NSLayoutConstraint(item: retweetPictureView!, attribute: .Top, relatedBy: .Equal, toItem: retweetTextContentLabel!, attribute: .Bottom, multiplier: 1, constant: ItemSize.DefaultSpace),
                    NSLayoutConstraint(item: retweetView!, attribute: .Bottom, relatedBy: .Equal, toItem: retweetPictureView!, attribute: .Bottom, multiplier: 1, constant: 10)
                    ])
                
                switch status.retweeted_status!.pic_urls.count {
                case 1...3:
                    retweetView?.addConstraint(NSLayoutConstraint(item: retweetPictureView!, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: rPictureSpace * 2 + rPictureWidth))
                case 4...6:
                    retweetView?.addConstraint(NSLayoutConstraint(item: retweetPictureView!, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: rPictureSpace * 3 + rPictureWidth * 2))
                case 7...9:
                    retweetView?.addConstraint(NSLayoutConstraint(item: retweetPictureView!, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: rPictureSpace * 4 + rPictureWidth * 3))
                default:
                    print("error retweetPictureAmount: \(status.retweeted_status!.pic_urls.count)")
                }
                for i in 0..<status.retweeted_status!.pic_urls.count {
                    //0 1 2
                    //3 4 5
                    //6 7 8
                    let row = CGFloat(i / 3)//0 1 2
                    let column = CGFloat(i % 3)//0 1 2
                    let imageView = AsyncImageView()
                    imageView.rootCell = self
                    imageView.index = i
                    imageView.userInteractionEnabled = true
                    imageView.contentMode = .ScaleAspectFit
                    imageView.setURL(status.retweeted_status!.pic_urls[i].thumbnailURL, placeholderImage: UIImage(named: "guapi"))
                    imageView.translatesAutoresizingMaskIntoConstraints = false
                    retweetPictureView!.addSubview(imageView)
                    retweetPictureView?.addConstraints([
                        NSLayoutConstraint(item: imageView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: rPictureWidth),
                        NSLayoutConstraint(item: imageView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: rPictureWidth),
                        NSLayoutConstraint(item: imageView, attribute: .Left, relatedBy: .Equal, toItem: retweetPictureView!, attribute: .Left, multiplier: 1, constant: (column + 1) * rPictureSpace + column * rPictureWidth),
                        NSLayoutConstraint(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: retweetPictureView!, attribute: .Top, multiplier: 1, constant: (row + 1) * rPictureSpace + row * rPictureWidth)
                        ])
                }
            } else {
                retweetView?.addConstraint(NSLayoutConstraint(item: retweetView!, attribute: .Bottom, relatedBy: .Equal, toItem: retweetTextContentLabel!, attribute: .Bottom, multiplier: 1, constant: 10))
            }
        }
        
        //button
        let width = (UIScreen.mainScreen().bounds.width - 10 * 2 - 5 * 3) / 4
        let topView = (
            status.hasPictures ?
                (status.hasRetweet ?retweetView!:pictureView!):
                (status.hasRetweet ?retweetView!:textContentLabel!)
        )
        sourceLabel = UILabel()
        sourceLabel?.text = status.source
        sourceLabel?.font = UIFont(name: "AvenirNext-UltraLight", size: 10)
        sourceLabel?.textAlignment = .Center
        sourceLabel?.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(sourceLabel!)
        contentView.addConstraints([
            NSLayoutConstraint(item: sourceLabel!, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: ItemSize.ButtonHeight),
            NSLayoutConstraint(item: sourceLabel!, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: width),
            NSLayoutConstraint(item: sourceLabel!, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: sourceLabel!, attribute: .Top, relatedBy: .Equal, toItem: topView, attribute: .Bottom, multiplier: 1, constant: ItemSize.HalfSpace)
            ])
        
        //attitudeButton
        attitudeButton = SpringButton()
        attitudeButton?.addTarget(self, action: "attitudeButtonPressed", forControlEvents: .TouchUpInside)
        
        attitudeButton?.setImage(UIImage(named:
            (status.liked ?? false) == true ? ImageNames.attitude_active:ImageNames.attitude_unactive
            ), forState: .Normal)
        
        attitudeButton?.setTitle("\(status.attitudes_count)", forState: .Normal)
        attitudeButton?.setTitleColor(UIColor.darkTextColor(), forState: .Normal)
        attitudeButton?.titleLabel?.textAlignment = .Right
        attitudeButton?.titleLabel?.font = UIFont(name: "Avenir-Light", size: 10)
        attitudeButton?.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(attitudeButton!)
        contentView.addConstraints([
            NSLayoutConstraint(item: attitudeButton!, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: ItemSize.ButtonHeight),
            NSLayoutConstraint(item: attitudeButton!, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: width),
            NSLayoutConstraint(item: attitudeButton!, attribute: .Left, relatedBy: .Equal, toItem: sourceLabel!, attribute: .Right, multiplier: 1, constant: 5),
            NSLayoutConstraint(item: attitudeButton!, attribute: .Bottom, relatedBy: .Equal, toItem: sourceLabel!, attribute: .Bottom, multiplier: 1, constant: 0)
            ])
        
        //repostButton
        repostButton = SpringButton()
        repostButton?.addTarget(self, action: "repostButtonPressed", forControlEvents: .TouchUpInside)
        repostButton?.setImage(UIImage(named: ImageNames.repost_unactive), forState: .Normal)
        repostButton?.setTitle("\(status.reposts_count)", forState: .Normal)
        repostButton?.setTitleColor(UIColor.darkTextColor(), forState: .Normal)
        repostButton?.titleLabel?.textAlignment = .Right
        repostButton?.titleLabel?.font = UIFont(name: "Avenir-Light", size: 10)
        repostButton?.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(repostButton!)
        contentView.addConstraints([
            NSLayoutConstraint(item: repostButton!, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height
                , multiplier: 1, constant: ItemSize.ButtonHeight),
            NSLayoutConstraint(item: repostButton!, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: width),
            NSLayoutConstraint(item: repostButton!, attribute: .Left, relatedBy: .Equal, toItem: attitudeButton!, attribute: .Right, multiplier: 1, constant: 5),
            NSLayoutConstraint(item: repostButton!, attribute: .Bottom, relatedBy: .Equal, toItem: attitudeButton!, attribute: .Bottom, multiplier: 1, constant: 0)
            ])
        
        //commentButton
        commentButton = SpringButton()
        commentButton?.addTarget(self, action: "commentButtonPressed", forControlEvents: .TouchUpInside)
        commentButton?.setImage(UIImage(named: ImageNames.comment_unactive), forState: .Normal)
        commentButton?.setTitle("\(status.comments_count)", forState: .Normal)
        commentButton?.setTitleColor(UIColor.darkTextColor(), forState: .Normal)
        commentButton?.titleLabel?.textAlignment = .Right
        commentButton?.titleLabel?.font = UIFont(name: "Avenir-Light", size: 10)
        commentButton?.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(commentButton!)
        contentView.addConstraints([
            NSLayoutConstraint(item: commentButton!, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: ItemSize.ButtonHeight),
            NSLayoutConstraint(item: commentButton!, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: width),
            NSLayoutConstraint(item: commentButton!, attribute: .Left, relatedBy: .Equal, toItem: repostButton!, attribute: .Right, multiplier: 1, constant: 5),
            NSLayoutConstraint(item: commentButton!, attribute: .Bottom, relatedBy: .Equal, toItem: repostButton!, attribute: .Bottom, multiplier: 1, constant: 0)
            ])
    }
    
    func attitudeButtonPressed() {
        attitudeButton!.animation = "pop"
        attitudeButton?.animate()
        var newState: Bool = status.liked!
        newState = !newState
        status.liked = newState
        if newState == true {
            attitudeButton?.setImage(UIImage(named: ImageNames.attitude_active), forState: .Normal)
            attitudeButton?.setTitle("\((Int((attitudeButton!.currentTitle ?? "0")) ?? 0) + 1)", forState: .Normal)
            NetWork.attitude(status.idstr!)
        } else {
            attitudeButton?.setImage(UIImage(named: ImageNames.attitude_unactive), forState: .Normal)
            attitudeButton?.setTitle("\((Int((attitudeButton!.currentTitle ?? "0")) ?? 0) - 1)", forState: .Normal)
            NetWork.destroyAttitude(status.idstr!)
        }
    }
    
    func repostButtonPressed() {
        repostButton!.animation = "pop"
        repostButton?.animate()
        delegate?.repost(withSender: self)
    }
    
    func commentButtonPressed() {
        commentButton!.animation = "pop"
        commentButton?.animate()
        delegate?.comment(withSender: self)
        
    }
    
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
