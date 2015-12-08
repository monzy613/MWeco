//
//  DetailStatusController.swift
//  MWeco
//
//  Created by 张逸 on 15/12/7.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

class DetailStatusController: UITableViewController {
    
    var tbController: TabBarController?
    var statusCell: StatusCell?
    
    var comments = [Comment]() {
        didSet {
            print("comments did set")
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        tbController?.showTabbar()
    }
    
    func initUI() {
        let screenBounds = UIScreen.mainScreen().bounds
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        
        //init headerView
        statusCell?.attitudeButton?.removeFromSuperview()
        statusCell?.repostButton?.removeFromSuperview()
        statusCell?.commentButton?.removeFromSuperview()
        let headCellHeight = Calculator.statusCellHeight(withStatus: statusCell!.status, andScreenWidth: screenBounds.width)
        let lineHeight: CGFloat = 0.35
        let line = UIView(frame: CGRect(x: 0, y: headCellHeight - lineHeight, width: screenBounds.width, height: lineHeight))
        line.backgroundColor = UIColor.lightGrayColor()
        statusCell?.contentView.addSubview(line)
        statusCell?.frame = CGRect(x: 0, y: 0, width: screenBounds.width, height: headCellHeight)
        tableView.tableHeaderView = statusCell
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return comments.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryboardNames.commentUserCell, forIndexPath: indexPath) as! CommentUserCell
        cell.configure(withComment: comments[indexPath.row])
        return cell
    }
}
