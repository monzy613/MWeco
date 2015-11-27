//
//  ReturnNavigationController.swift
//  MWeco
//
//  Created by Monzy on 15/11/27.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

class ReturnNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(animated: Bool) {
        print("viewWillDisappear")
    }
}
