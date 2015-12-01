//
//  TopWeiboTableViewController.swift
//  MWeco
//
//  Created by Monzy on 15/11/19.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

class TopWeiboTableViewController: UITableViewController, StatusCellDelegate {
    
    private var loadingView: MZLoadingView?
    override func viewDidLoad() {
        super.viewDidLoad()
        currentTabIndex = 0
        registerFor3DTouch()
        initUI()
        if publicStatuses.count == 0 {
            loadStatus()
        }
        
        self.refreshControl?.addTarget(self, action: "loadStatus", forControlEvents: .ValueChanged)
    }
    
    private func initUI() {
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
    }
    
    func loadStatus() {
        loadingView = MZLoadingView(rootView: (self.navigationController?.view)!, effect: UIBlurEffect(style: .Dark))
        loadingView?.start()
        NetWork.getTimeLine(.FriendTimeLine
            , onSuccess: {
                status in
                print("onSuccess \(status.count) new weibo")
                NetWork.getUserInfo({
                    json in
                    currentUserInfo = Blogger(withJSON: json)
                    }, onFailure: {})
                publicStatuses = status
                self.tableView.reloadData()
                if self.refreshControl?.refreshing == true {
                    self.refreshControl?.endRefreshing()
                }
                if self.loadingView?.isAnimating() == true {
                    self.loadingView?.stop()
                }
                NetWork.getTimeLine(.SelfTimeLine
                    , onSuccess: {
                        status in
                        selfStatuses = status
                    }, onFailure: {
                })
            }, onFailure: {
                self.performSegueWithIdentifier("LoginSegue", sender: self)
        })
    }

    func registerFor3DTouch() {
        if traitCollection.forceTouchCapability == .Available {
            registerForPreviewingWithDelegate(self, sourceView: self.view)
        } else {
            print("force touch not available")
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return publicStatuses.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = StatusCell(withStatus: publicStatuses[indexPath.row], style: .Default, reuseIdentifier: "StatusCell")
        cell.delegate = self
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Calculator.statusCellHeight(withStatus: publicStatuses[indexPath.row], andScreenWidth: UIScreen.mainScreen().bounds.width)
    }

    
    func repost(withSender sender: AnyObject) {
        performSegueWithIdentifier(Segues.Repost, sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Segues.Repost:
                if let editorController = (segue.destinationViewController as? UINavigationController)?.visibleViewController as? EditorViewController {
                    editorController.retweetStatus = (sender as! StatusCell).status
                    editorController.hasRetweetStatus = true
                }
            default:
                break
            }
        }
    }
    
}
