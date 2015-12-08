//
//  Extensions.swift
//  MWeco
//
//  Created by Monzy on 15/11/26.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

extension TopWeiboTableViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        showViewController(viewControllerToCommit, sender: self)
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let previewVC = storyboard?.instantiateViewControllerWithIdentifier("PreviewPictureController") as! PreviewPictureController? else {
            return nil
        }
        
        let notifCenter = MZNotificationCenter.getInstance()
        
        if let rectToShow = notifCenter.currentOnTouchImageBounds {
            previewingContext.sourceRect = rectToShow
        } else {
            return nil
        }
        
        if let ratio = notifCenter.imageRatio {
            //ratio is height / width
            let width = UIScreen.mainScreen().bounds.width * 0.9
            let height = width * CGFloat(ratio)
            previewVC.preferredContentSize = CGSize(width: width, height: height)
        } else {
            return nil
        }
        
        if let path = notifCenter.currentOnTouchImagePath {
            previewVC.imageURL = NSURL(string: path)
            return previewVC
        } else {
            return nil
        }
    }
}

class DetailImageInfo: AnyObject {
    var index: Int = 0
    var pic_urls = [PictureURL]()
    
    init(withIndex index: Int, andPics pics: [PictureURL]) {
        self.index = index
        self.pic_urls = pics
    }
}

extension AsyncImageView {
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if self.tag != 0 {
            return
        }
        var sView: UIView = self.superview!
        while true {
            if sView.isKindOfClass(UITableView) {
                print("is tableView")
                break
            } else {
                sView = sView.superview!
            }
        }
        let bounds = self.convertRect(self.bounds, toView: sView)
        guard let imgSize = self.image?.size else {return}
        let ratio = Double(imgSize.height / imgSize.width)
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationNames.StartTouchImageView, object: nil, userInfo: [
            "MyBounds": MyBounds(bounds: bounds),
            "url": self.url ?? NSURL(),
            "ratio": ratio
            ])
    }
    
    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationNames.EndTouchImageView, object: nil)
        if let statusCell = rootCell as? StatusCell {
            if let retweetStatus = statusCell.status.retweeted_status {
                statusCell.delegate?.detailImage(withSender: DetailImageInfo(withIndex: index, andPics: retweetStatus.pic_urls))
            } else {
                statusCell.delegate?.detailImage(withSender: DetailImageInfo(withIndex: index, andPics: statusCell.status.pic_urls))
            }
        }
        print("touchesEnded")
    }
    
    public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationNames.EndTouchImageView, object: nil)
        print("touchesCancelled")
    }
}