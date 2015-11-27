//
//  TabBarController.swift
//  MWeco
//
//  Created by Monzy on 15/11/26.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    var addButton: SpringButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        if isReturnFromEditVC == true {
            isReturnFromEditVC = false
        }
        initAddButton()
        self.delegate?.tabBarController!(self, shouldSelectViewController: viewControllers![currentTabIndex])
        selectedIndex = currentTabIndex
        print("CurrentTab: \(currentTabIndex)")
    }

    func initAddButton() {
        let height = tabBar.frame.height * 0.8
        let width = height * 4 / 3
        let startX = tabBar.frame.midX - width / 2
        let startY = tabBar.frame.midY - height / 2
        
        addButton = SpringButton(type: .System)
        addButton?.backgroundColor = UIColor(hex6: 0x007FFF)
        addButton?.setImage(UIImage(named: ImageNames.addIcon), forState: .Normal)
        addButton?.imageView?.contentMode = .ScaleAspectFit
        addButton?.tintColor = UIColor.whiteColor()
        //addButton?.setBackgroundImage(UIImage(named: ImageNames.addButton), forState: .Normal)
        addButton?.frame = CGRect(x: startX, y: startY, width: width, height: height)
        addButton?.layer.cornerRadius = width / 10
        addButton?.clipsToBounds = true
        addButton?.addTarget(self, action: "addButtonPressed", forControlEvents: .TouchUpInside)
        self.view.addSubview(addButton!)
    }
    
    func addButtonPressed() {
        print("addButton touched")
        addButton?.animation = "pop"
        addButton?.force = 0.25
        addButton?.animate()
        performSegueWithIdentifier(Segues.StatusMenu, sender: self)
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        return true
    }
    
}
