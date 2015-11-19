//
//  ViewController.swift
//  MWeco
//
//  Created by Monzy on 15/11/19.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    // Mark outlets
    
    // Mark actions
    @IBAction func loginActionPressed(sender: UIButton) {
        NetWork.revokeOauth()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NetWork.getTokenExpireTime()
    }
}

