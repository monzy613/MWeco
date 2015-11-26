//
//  TopWeiboTableViewController.swift
//  MWeco
//
//  Created by Monzy on 15/11/19.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

class TopWeiboTableViewController: UITableViewController {
    
    private var publicStatuses = [Status]()
    private var loadingView: MZLoadingView?
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        loadStatus()
        registerFor3DTouch()
        
        self.refreshControl?.addTarget(self, action: "loadStatus", forControlEvents: .ValueChanged)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    private func initUI() {
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        loadingView = MZLoadingView(rootView: (self.navigationController?.view)!, effect: UIBlurEffect(style: .Dark))
        loadingView?.start()
    }
    
    func loadStatus() {
        NetWork.getFriendTimeline({
            [unowned self]
            status in
            print("onSuccess \(status.count) new weibo")
            self.publicStatuses = status
            self.tableView.reloadData()
            if self.refreshControl?.refreshing == true {
                self.refreshControl?.endRefreshing()
            }
            if self.loadingView?.isAnimating() == true {
                self.loadingView?.stop()
            }
            }, onFailure: {
                [unowned self] in
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
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Calculator.statusCellHeight(withStatus: publicStatuses[indexPath.row], andScreenWidth: UIScreen.mainScreen().bounds.width)
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
