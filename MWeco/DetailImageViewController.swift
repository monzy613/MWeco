//
//  DetailImageViewController.swift
//  MWeco
//
//  Created by 张逸 on 15/12/8.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

class DetailImageViewController: UIViewController {
    var tbController: TabBarController?
    var baseScrollView: UIScrollView?
    var pic_urls = [PictureURL]()
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    @IBAction func panGestoreAction(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Ended:
            print("End pan with velocity: \(sender.velocityInView(baseScrollView))")
            let velocity = sender.velocityInView(baseScrollView)
            if velocity.y > 0 {
                if abs(velocity.x) < 0.5 * abs(velocity.y) {
                    tbController?.showTabbar()
                    dismissViewControllerAnimated(true, completion: {})
                }
            }
        default:
            break
        }
    }
    
    func initUI() {
        let scBounds = UIScreen.mainScreen().bounds
        baseScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: scBounds.width, height: scBounds.height))
        baseScrollView?.backgroundColor = UIColor.clearColor()
        baseScrollView?.contentSize = CGSize(width: CGFloat(pic_urls.count) * scBounds.width, height: scBounds.height)
        baseScrollView?.contentOffset = CGPoint(x: CGFloat(index) * scBounds.width, y: 0)
        baseScrollView?.showsHorizontalScrollIndicator = false
        baseScrollView?.showsVerticalScrollIndicator = false
        baseScrollView?.pagingEnabled = true
        view.addSubview(baseScrollView!)
        
        for (index, pic_url) in pic_urls.enumerate() {
            let singleImgView = SingleImageView(withImageURL: pic_url.bmiddleURL, frame: CGRect(x: CGFloat(index) * scBounds.width, y: 0, width: scBounds.width, height: scBounds.height))
            baseScrollView?.addSubview(singleImgView)
        }
    }
}
