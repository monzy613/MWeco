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
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return selfStatuses.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(StoryboardNames.userInfoCell, forIndexPath: indexPath) as! UserInfoCell
            if let userInfo = currentUserInfo {
                cell.configure(withUserInfo: userInfo)
            } else {
                let userInfo = Blogger()
                userInfo.screen_name = "nil"
                userInfo.gender = nil
                userInfo.location = nil
                cell.configure(withUserInfo: userInfo)
            }
            return cell
        } else {
            let cell = StatusCell(withStatus: selfStatuses[indexPath.row], style: .Default, reuseIdentifier: "StatusCell")
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return Calculator.statusCellHeight(withStatus: selfStatuses[indexPath.row], andScreenWidth: UIScreen.mainScreen().bounds.width)
        } else {
            return UIScreen.mainScreen().bounds.width * 0.725
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }

}
