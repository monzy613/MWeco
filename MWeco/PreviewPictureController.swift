//
//  PreviewPictureController.swift
//  MWeco
//
//  Created by Monzy on 15/11/26.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

class PreviewPictureController: UIViewController {

    var imageURL: NSURL?
    
    lazy var previewActions: [UIPreviewActionItem] = {
        let downloadAction = UIPreviewAction(title: "下载", style: .Default) {
            action, viewController in
            
        }
        let attitudeAction = UIPreviewAction(title: "赞", style: .Default) {
            action, viewControllre in
        }
        return [downloadAction, attitudeAction]
    }()
    
    @IBOutlet var imageViewToPreview: AsyncImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = imageURL {
            self.imageViewToPreview.url = url
        }
    }
    
    override func previewActionItems() -> [UIPreviewActionItem] {
        return previewActions
    }
}
