//
//  SelfTableViewController.swift
//  MWeco
//
//  Created by Monzy on 15/11/19.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

class SelfTableViewController: UITableViewController {
    
    //20 statuses and 1 userInfo

    override func viewDidLoad() {
        super.viewDidLoad()
        currentTabIndex = 4
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
        let lineWidth: CGFloat = 0.5
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
        let recentButton = SpringButton()
        let bySelfButton = SpringButton()
        let albumButton = SpringButton()
        let favorButton = SpringButton()
        recentButton.setTitle("最近", forState: .Normal)
        recentButton.titleLabel?.font = UIFont(name: "Avenir-Regular", size: 15)
        recentButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        bySelfButton.setTitle("原创", forState: .Normal)
        bySelfButton.titleLabel?.font = UIFont(name: "Avenir-Regular", size: 15)
        bySelfButton.setTitleColor(UIColor(hex6: 0x8B8FFF), forState: .Normal)
        albumButton.setTitle("相册", forState: .Normal)
        albumButton.titleLabel?.font = UIFont(name: "Avenir-Regular", size: 15)
        albumButton.setTitleColor(UIColor(hex6: 0x8B8FFF), forState: .Normal)
        favorButton.setTitle("收藏", forState: .Normal)
        favorButton.titleLabel?.font = UIFont(name: "Avenir-Regular", size: 15)
        favorButton.setTitleColor(UIColor(hex6: 0x8B8FFF), forState: .Normal)
        recentButton.frame = CGRect(x: 0, y: startY, width: btWidth, height: btHeight)
        bySelfButton.frame = CGRect(x: btWidth + lineWidth, y: startY, width: btWidth, height: btHeight)
        albumButton.frame = CGRect(x: 2 * (btWidth + lineWidth) , y: startY, width: btWidth, height: btHeight)
        favorButton.frame = CGRect(x: 3 * (btWidth + lineWidth), y: startY, width: btWidth, height: btHeight)
        headerView.addSubview(recentButton)
        headerView.addSubview(bySelfButton)
        headerView.addSubview(albumButton)
        headerView.addSubview(favorButton)
        
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
        case 1:
            startX = labelWidth
        case 2:
            startX = 2 * labelWidth
        default:
            break
        }
        
        amountLabel.text = "\(amount)"
        amountLabel.textAlignment = .Center
        amountLabel.font = UIFont(name: "Avenir-Regular", size: amountLabelHeight)
        amountLabel.textColor = UIColor.whiteColor()
        amountLabel.frame = CGRect(x: startX, y: startY + labelSpace * 2, width: labelWidth, height: amountLabelHeight)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "Avenir-Regular", size: titleLabelHeight)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.frame = CGRect(x: startX, y: startY + labelSpace * 2 + amountLabelHeight, width: labelWidth, height: titleLabelHeight)
        
        
        rootView.addSubview(amountLabel)
        rootView.addSubview(titleLabel)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selfStatuses.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = StatusCell(withStatus: selfStatuses[indexPath.row], style: .Default, reuseIdentifier: "StatusCell")
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Calculator.statusCellHeight(withStatus: selfStatuses[indexPath.row], andScreenWidth: UIScreen.mainScreen().bounds.width)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
