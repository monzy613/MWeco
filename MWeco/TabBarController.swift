//
//  TabBarController.swift
//  MWeco
//
//  Created by Monzy on 15/11/26.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit
import pop

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    var addButton: SpringButton?
    var addButtonShowPoint: CGPoint?
    var addButtonHidePoint: CGPoint?

    override func viewDidLoad() {
        super.viewDidLoad()
        if isReturnFromEditVC == true {
            isReturnFromEditVC = false
        }
        initAddButton()
        self.delegate?.tabBarController!(self, shouldSelectViewController: viewControllers![currentTabIndex])
        selectedIndex = currentTabIndex
        setTabSelected(withIndex: selectedIndex)
        print("CurrentTab: \(currentTabIndex)")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("tab vwa")
    }

    func initAddButton() {
        let height = tabBar.frame.height * 0.85
        let width = height * 6 / 5
        let startX = tabBar.frame.midX - width / 2
        let startY = tabBar.frame.midY - height / 2
        
        addButton = SpringButton(type: .System)
        addButton?.backgroundColor = UIColor(hex6: 0x007FFF)
        addButton?.setImage(UIImage(named: ImageNames.addIcon), forState: .Normal)
        addButton?.imageView?.contentMode = .ScaleAspectFit
        addButton?.tintColor = UIColor.whiteColor()
        //addButton?.setBackgroundImage(UIImage(named: ImageNames.addButton), forState: .Normal)
        addButton?.frame = CGRect(x: startX, y: startY, width: width, height: height)
        addButton?.layer.cornerRadius = width / 15
        addButton?.clipsToBounds = true
        addButton?.addTarget(self, action: "addButtonPressed", forControlEvents: .TouchUpInside)
        self.view.addSubview(addButton!)
        addButtonShowPoint = CGPoint(x: (addButton?.frame.midX)!, y: (addButton?.frame.midY)!)
        addButtonHidePoint = addButtonShowPoint
        addButtonHidePoint?.y += (height + (UIScreen.mainScreen().bounds.height - (addButton?.frame.midY)! - height / 2))
    }
    
    func addButtonPressed() {
        print("addButton touched")
        addButton?.animation = "pop"
        addButton?.force = 0.25
        addButton?.animate()
        performSegueWithIdentifier(Segues.StatusMenu, sender: self)
    }
    
    
    func hideTabbar() {
        move(tabBar, destPoint: CGPoint(x: tabBar.frame.midX, y: UIScreen.mainScreen().bounds.height + tabBar.frame.height / 2))
        move(addButton!, destPoint: addButtonHidePoint!)
    }
    
    func showTabbar() {
        move(tabBar, destPoint: CGPoint(x: tabBar.frame.midX, y: UIScreen.mainScreen().bounds.height - tabBar.frame.height / 2))
        move(addButton!, destPoint: addButtonShowPoint!)
    }

    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        return true
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        guard let index = self.tabBar.items?.indexOf(item) else {return}
        print("itemIndex: \(index)")
        setTabSelected(withIndex: index)
    }
    
    func setTabSelected(withIndex index: Int) {
        for (i, element) in (self.tabBar.items!).enumerate() {
            if i != index {
                element.image = Tabbar.tabbarImage(withIndex: i, andState: .UnSelected)
            }
        }
    }
}
