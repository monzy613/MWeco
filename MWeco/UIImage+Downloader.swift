//
//  UIImage+Downloader.swift
//  M_fm
//
//  Created by 张逸 on 16/4/11.
//  Copyright © 2016年 MonzyZhang. All rights reserved.
//

import UIKit

extension UIImage {
    class func download(withURL url: String) -> UIImage {
        let data = NSData(contentsOfURL: NSURL(string: url)!)
        return UIImage(data: data!)!
    }
}