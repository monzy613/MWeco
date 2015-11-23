//
//  SettingTableViewController.swift
//  MWeco
//
//  Created by Monzy on 15/11/23.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {
    private var loadingView: MZLoadingView?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView = MZLoadingView(rootView: (self.navigationController?.view)!, effect: UIBlurEffect(style: .Dark))
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 4 && indexPath.row == 0 {
            loadingView?.start()
            NetWork.revokeOauth {
                [unowned self] in
                self.loadingView?.stop()
                SaveData.remove(withKey: .ACCESS_TOKEN)
            }
            print("revokeOauth")
        }
    }

}
