//
//  SettingTableViewController.swift
//  MWeco
//
//  Created by Monzy on 15/11/23.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 4 && indexPath.row == 0 {
            NetWork.revokeOauth {
                SaveData.remove(withKey: .ACCESS_TOKEN)
            }
            print("revokeOauth")
        }
    }

}
