//
//  SelfTableViewController.swift
//  MWeco
//
//  Created by Monzy on 15/11/19.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

class SelfTableViewController: UITableViewController {
    
    //some constants
    let buttonHighlightedColor = UIColor.blueColor()
    let buttonNormalColor = UIColor(hex6: 0x8B8FFF)
    
    
    //20 statuses and 1 userInfo
    
    //buttons
    let recentButton = SpringButton()
    let bySelfButton = SpringButton()
    let albumButton = SpringButton()
    let favorButton = SpringButton()
    
    let statusesButton = SpringButton()
    let friendsButton = SpringButton()
    let followersButton = SpringButton()
    
    
    //data
    var statuses = [Status]()

    override func viewDidLoad() {
        super.viewDidLoad()
        currentTabIndex = 4
        statuses = selfStatuses
        initUI()
    }
    
    func initUI() {
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = headerView()
    }
    
    func headerView() -> UIView {
        
        guard let blogger = currentUserInfo else {
            return UIView()
        }
        let lineWidth: CGFloat = 0.3
        let headerView = UIView()
        let width = UIScreen.mainScreen().bounds.width
        let height = width * 0.725 + lineWidth * 2
        headerView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        //bgImageView
        let bgImageView = SpringImageView()
        let bgWidth = width
        let bgHeight = bgWidth * 200 / 320
        bgImageView.frame = CGRect(x: 0, y: 0, width: bgWidth, height: bgHeight)
        bgImageView.contentMode = .ScaleAspectFill
        bgImageView.clipsToBounds = true
        bgImageView.image = UIImage(data: NSData(contentsOfURL: blogger.avatar_largeURL!)!)
        headerView.addSubview(bgImageView)
        
        //blur view
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        blurView.frame = CGRect(x: 0, y: 0, width: bgWidth, height: bgHeight + lineWidth)
        headerView.addSubview(blurView)
        
        //line
        let line = UIView()
        line.backgroundColor = UIColor.blueColor()
        line.frame = CGRect(x: 0, y: bgHeight, width: width, height: lineWidth)
        headerView.addSubview(line)
        
        //avatarImageView
        let avatarImageView = SpringImageView()
        let aWidth = height * 0.35
        avatarImageView.frame = CGRect(x: (bgWidth - aWidth) / 2, y: (bgHeight - aWidth) / 2, width: aWidth, height: aWidth)
        avatarImageView.contentMode = .ScaleAspectFit
        avatarImageView.image = UIImage(data: NSData(contentsOfURL: blogger.avatar_largeURL!)!)
        avatarImageView.layer.cornerRadius = aWidth / 2
        avatarImageView.clipsToBounds = true
        headerView.addSubview(avatarImageView)
        
        //name, gender, location etc label
        let space = (bgHeight - aWidth) / 2
        let topLabelSpace = space / 10
        let nameLabel = UILabel()
        let nameLabelHeight = (space - topLabelSpace * 2) / 3
        nameLabel.text = blogger.screen_name
        nameLabel.font = UIFont(name: "Avenir-Light", size: nameLabelHeight)
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.textAlignment = .Center
        nameLabel.frame = CGRect(x: 0, y: topLabelSpace, width: width, height: nameLabelHeight)
        
        let genderLabel = UILabel()
        let genderLabelHeight = nameLabelHeight * 2 / 3
        genderLabel.text = blogger.gender
        genderLabel.font = UIFont(name: "Avenir-Light", size: genderLabelHeight)
        genderLabel.textColor = UIColor.whiteColor()
        genderLabel.textAlignment = .Right
        genderLabel.frame = CGRect(x: 0, y: nameLabelHeight + topLabelSpace * 2, width: (width - topLabelSpace) / 2, height: genderLabelHeight)
        
        let locationLabel = UILabel()
        locationLabel.text = blogger.location
        locationLabel.font = UIFont(name: "Avenir-Light", size: genderLabelHeight)
        locationLabel.textColor = UIColor.whiteColor()
        locationLabel.textAlignment = .Left
        locationLabel.frame = CGRect(x: (width / 2) + topLabelSpace, y: nameLabelHeight + topLabelSpace * 2, width: (width - topLabelSpace) / 2, height: genderLabelHeight)
        
        headerView.addSubview(nameLabel)
        headerView.addSubview(genderLabel)
        headerView.addSubview(locationLabel)
        
        //amount labels
        amountLabel(headerView, title: "微博", amount: blogger.statuses_count, startY: (bgHeight + aWidth) / 2, superWidth: width, space: space, location: 0)
        amountLabel(headerView, title: "关注", amount: blogger.friends_count, startY: (bgHeight + aWidth) / 2, superWidth: width, space: space, location: 1)
        amountLabel(headerView, title: "粉丝", amount: blogger.followers_count, startY: (bgHeight + aWidth) / 2, superWidth: width, space: space, location: 2)
        
        //buttons
        let btWidth = (width - 3 * lineWidth) / 4
        let btHeight = (height - bgHeight - lineWidth)
        let startY = bgHeight + lineWidth
        recentButton.setTitle("最近", forState: .Normal)
        recentButton.titleLabel?.font = UIFont(name: "Avenir-Light", size: 15)
        recentButton.setTitleColor(buttonHighlightedColor, forState: .Normal)
        recentButton.addTarget(self, action: "recentButtonPressed:", forControlEvents: .TouchUpInside)
        bySelfButton.setTitle("原创", forState: .Normal)
        bySelfButton.titleLabel?.font = UIFont(name: "Avenir-Light", size: 15)
        bySelfButton.setTitleColor(buttonNormalColor, forState: .Normal)
        bySelfButton.addTarget(self, action: "bySelfButtonPressed:", forControlEvents: .TouchUpInside)
        albumButton.setTitle("相册", forState: .Normal)
        albumButton.titleLabel?.font = UIFont(name: "Avenir-Light", size: 15)
        albumButton.setTitleColor(buttonNormalColor, forState: .Normal)
        albumButton.addTarget(self, action: "albumButtonPressed:", forControlEvents: .TouchUpInside)
        favorButton.setTitle("收藏", forState: .Normal)
        favorButton.titleLabel?.font = UIFont(name: "Avenir-Light", size: 15)
        favorButton.setTitleColor(buttonNormalColor, forState: .Normal)
        favorButton.addTarget(self, action: "favorButtonPressed:", forControlEvents: .TouchUpInside)
        
        recentButton.frame = CGRect(x: 0, y: startY, width: btWidth, height: btHeight)
        bySelfButton.frame = CGRect(x: btWidth + lineWidth, y: startY, width: btWidth, height: btHeight)
        albumButton.frame = CGRect(x: 2 * (btWidth + lineWidth) , y: startY, width: btWidth, height: btHeight)
        favorButton.frame = CGRect(x: 3 * (btWidth + lineWidth), y: startY, width: btWidth, height: btHeight)
        headerView.addSubview(recentButton)
        headerView.addSubview(bySelfButton)
        headerView.addSubview(albumButton)
        headerView.addSubview(favorButton)
        
        //vertical lines
        for i in 0...2 {
            let vLineHeight = 0.8 * btHeight
            let vLine = UIView()
            vLine.backgroundColor = UIColor.blueColor()
            vLine.frame = CGRect(x: btWidth * (CGFloat(i) + 1), y: startY + (btHeight - vLineHeight) / 2, width: lineWidth, height: vLineHeight)
            headerView.addSubview(vLine)
        }
        
        //bottomline
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.blueColor()
        bottomLine.frame = CGRect(x: 0, y: bgHeight + lineWidth + btHeight, width: width, height: lineWidth)
        headerView.addSubview(bottomLine)
        return headerView
    }
    
    func amountLabel(rootView: UIView, title: String, amount: Int, startY: CGFloat, superWidth: CGFloat, space: CGFloat, location: Int) {
        let labelSpace = space / 10
        let amountLabelHeight = (space - labelSpace * 2) / 3
        let labelWidth = superWidth / 3
        let titleLabelHeight = amountLabelHeight * 2 / 3
        let amountLabel = UILabel()
        
        var startX: CGFloat = 0
        switch location {
        case 0:
            startX = 0
            statusesButton.frame = CGRect(x: startX, y: startY, width: labelWidth, height: amountLabelHeight + labelSpace * 2 + titleLabelHeight)
            statusesButton.addTarget(self, action: "statusesButtonPressed:", forControlEvents: .TouchUpInside)
            rootView.addSubview(statusesButton)
        case 1:
            startX = labelWidth
            friendsButton.frame = CGRect(x: startX, y: startY, width: labelWidth, height: amountLabelHeight + labelSpace * 2 + titleLabelHeight)
            friendsButton.addTarget(self, action: "friendsButtonPressed:", forControlEvents: .TouchUpInside)
            rootView.addSubview(friendsButton)
        case 2:
            startX = 2 * labelWidth
            followersButton.frame = CGRect(x: startX, y: startY, width: labelWidth, height: amountLabelHeight + labelSpace * 2 + titleLabelHeight)
            followersButton.addTarget(self, action: "followersButtonPressed:", forControlEvents: .TouchUpInside)
            rootView.addSubview(followersButton)
        default:
            break
        }
        
        amountLabel.text = "\(amount)"
        amountLabel.textAlignment = .Center
        amountLabel.font = UIFont(name: "Avenir-Light", size: amountLabelHeight)
        amountLabel.textColor = UIColor.whiteColor()
        amountLabel.frame = CGRect(x: startX, y: startY + labelSpace * 2, width: labelWidth, height: amountLabelHeight)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont(name: "Avenir-Medium", size: titleLabelHeight)
        titleLabel.textAlignment = .Center
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.frame = CGRect(x: startX, y: startY + labelSpace * 3 + amountLabelHeight, width: labelWidth, height: titleLabelHeight)
        
        
        rootView.addSubview(amountLabel)
        rootView.addSubview(titleLabel)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = StatusCell(withStatus: statuses[indexPath.row], style: .Default, reuseIdentifier: "StatusCell")
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Calculator.statusCellHeight(withStatus: statuses[indexPath.row], andScreenWidth: UIScreen.mainScreen().bounds.width)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func recentButtonPressed(sender: SpringButton) {
        sender.animation = "pop"
        sender.animate()
        sender.setTitleColor(buttonHighlightedColor, forState: .Normal)
        bySelfButton.setTitleColor(buttonNormalColor, forState: .Normal)
        albumButton.setTitleColor(buttonNormalColor, forState: .Normal)
        favorButton.setTitleColor(buttonNormalColor, forState: .Normal)
        if statuses != selfStatuses {
            statuses = selfStatuses
            tableView.reloadData()
        }
    }
    
    func bySelfButtonPressed(sender: SpringButton) {
        sender.animation = "pop"
        sender.animate()
        sender.setTitleColor(buttonHighlightedColor, forState: .Normal)
        recentButton.setTitleColor(buttonNormalColor, forState: .Normal)
        albumButton.setTitleColor(buttonNormalColor, forState: .Normal)
        favorButton.setTitleColor(buttonNormalColor, forState: .Normal)
        if statuses == selfStatuses {
            statuses = []
            for status in selfStatuses {
                if status.hasRetweet == false {
                    statuses.append(status)
                }
            }
            tableView.reloadData()
        }
    }
    
    func albumButtonPressed(sender: SpringButton) {
        sender.animation = "pop"
        sender.animate()
        sender.setTitleColor(buttonHighlightedColor, forState: .Normal)
        bySelfButton.setTitleColor(buttonNormalColor, forState: .Normal)
        recentButton.setTitleColor(buttonNormalColor, forState: .Normal)
        favorButton.setTitleColor(buttonNormalColor, forState: .Normal)
    }
    
    func favorButtonPressed(sender: SpringButton) {
        sender.animation = "pop"
        sender.animate()
        sender.setTitleColor(buttonHighlightedColor, forState: .Normal)
        bySelfButton.setTitleColor(buttonNormalColor, forState: .Normal)
        albumButton.setTitleColor(buttonNormalColor, forState: .Normal)
        recentButton.setTitleColor(buttonNormalColor, forState: .Normal)
    }
    
    func statusesButtonPressed(sender: SpringButton) {
        print("statuses")
    }
    
    func friendsButtonPressed(sender: SpringButton) {
        print("friends")
    }
    
    func followersButtonPressed(sedner: SpringButton) {
        print("followers")
    }

}
