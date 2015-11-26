//
//  Calculator.swift
//  AutoLayoutByCode
//
//  Created by Monzy on 15/11/25.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

class Calculator {
    class func statusCellHeight(withStatus status: Status, andScreenWidth screenWidth: CGFloat) -> CGFloat {
        var cellHeight: CGFloat = 0
        let contentTextHeight = labelHeight(withText: status.text ?? "", andFont: UIFont(name: "Avenir-Light", size: 15)!, andLabelWidth: (screenWidth - 20))
        cellHeight += ItemSize.DefaultSpace
        cellHeight += ItemSize.AvatarHeight
        cellHeight += ItemSize.DefaultSpace
        if status.text != "" {
            cellHeight += contentTextHeight
            cellHeight += ItemSize.DefaultSpace
        } else {
            print("empty status")
        }
        cellHeight += ItemSize.ButtonHeight //button height
        
        //if has pictures
        if status.hasPictures {
            let pictureViewWidth = UIScreen.mainScreen().bounds.width - ItemSize.DefaultSpace * 2
            let pictureSpace = pictureViewWidth / 20
            let pictureWidth = (pictureViewWidth - 4 * pictureSpace) / 3
            
            switch status.pic_urls.count {
            case 1...3:
                cellHeight += (pictureSpace * 2 + pictureWidth)
            case 4...6:
                cellHeight += (pictureSpace * 3 + pictureWidth * 2)
            case 7...9:
                cellHeight += (pictureSpace * 4 + pictureWidth * 3)
            default:
                break
            }
            cellHeight += ItemSize.DefaultSpace
        }
        
        //if has retweetStatus
        if status.hasRetweet {
            let retweetViewWidth = UIScreen.mainScreen().bounds.width - ItemSize.DefaultSpace * 2
            let retweetTextContentLabelWidth = retweetViewWidth - 10 * 2
            var retweetStatusHeight: CGFloat = 0
            retweetStatusHeight += labelHeight(withText: status.retweeted_status!.blogger!.screen_name ?? "nilScreenName", andFont: FONT_RETWEETSCREENNAME!, andLabelWidth: retweetTextContentLabelWidth)
            retweetStatusHeight += labelHeight(withText: status.retweeted_status!.text ?? "nilText", andFont: FONT_RETWEETTEXT!, andLabelWidth: retweetTextContentLabelWidth)
            cellHeight += ItemSize.DefaultSpace * 4//spaces
            
            if status.retweeted_status!.hasPictures {
                let rPictureViewWidth = retweetViewWidth - ItemSize.DefaultSpace * 2
                let rPictureSpace = rPictureViewWidth / 20
                let rPictureWidth = (rPictureViewWidth - 4 * rPictureSpace) / 3
                
                switch status.retweeted_status!.pic_urls.count {
                case 1...3:
                    retweetStatusHeight += (rPictureSpace * 2 + rPictureWidth)
                case 4...6:
                    retweetStatusHeight += (rPictureSpace * 3 + rPictureWidth * 2)
                case 7...9:
                    retweetStatusHeight += (rPictureSpace * 4 + rPictureWidth * 3)
                default:
                    break
                }
                retweetStatusHeight += ItemSize.DefaultSpace
            }
            cellHeight += retweetStatusHeight
        }
        
        
        return cellHeight
    }
    
    
    class func labelHeight(withText text: String, andFont font: UIFont, andLabelWidth width: CGFloat) -> CGFloat {
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .ByCharWrapping
        style.alignment = .Left
        let attributedString = NSAttributedString(string: text, attributes: [NSFontAttributeName: font, NSParagraphStyleAttributeName: style])
        let rect = attributedString.boundingRectWithSize(CGSize(width: width, height: CGFloat.max), options: .UsesLineFragmentOrigin, context: nil)
        return rect.height
    }
    
}
