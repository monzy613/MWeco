//
//  SingleImageView.swift
//  MWeco
//
//  Created by 张逸 on 15/12/8.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

class SingleImageView: UIScrollView, UIScrollViewDelegate {
    
    var imageView: AsyncImageView?

    init(withImageURL url: NSURL, frame: CGRect) {
        super.init(frame: frame)
        imageView = AsyncImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        imageView?.setURL(url, placeholderImage: UIImage(named: ImageNames.defaultAvatar))
        imageView?.contentMode = .ScaleAspectFit
        self.addSubview(imageView!)
        self.sizeToFit()
        self.delegate = self
        self.minimumZoomScale = 1
        self.maximumZoomScale = 3.0
    }

    init(withImg img: UIImage, frame: CGRect) {
        super.init(frame: frame)
        imageView = AsyncImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        imageView?.image = img
        imageView?.contentMode = .ScaleAspectFit
        self.backgroundColor = UIColor.clearColor()
        self.addSubview(imageView!)
        self.sizeToFit()
        self.delegate = self
        self.minimumZoomScale = 1
        self.maximumZoomScale = 3.0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }

}
