//
//  UserListController.swift
//  MWeco
//
//  Created by 张逸 on 15/12/4.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit


enum UserListType {
    case Following
    case FollowMe
}

class UserListController: UITableViewController {
    var listData = [Blogger]()
    
    @IBAction func dismissButtonPressed(sender: UIBarButtonItem) {
        self.navigationController?.dismissViewControllerAnimated(true) {}
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    func initUI() {
        tableView.tableFooterView = UIView()
    }
    
    func initData(withType type: UserListType) {
        listData = []
        switch type {
        case .Following:
            listData = followings
        case .FollowMe:
            listData = followers
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listData.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserInfoCell", forIndexPath: indexPath) as! UserInfoCell
        cell.configure(withUserInfo: listData[indexPath.row])
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as! UserInfoCell
        selectedCell.follow_unfollowButton.backgroundColor = Colors.userInfoFollowButton
    }

}
