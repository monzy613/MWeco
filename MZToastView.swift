//
//  MZToastView.swift
//  Toast
//
//  Created by Monzy on 15/11/3.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

enum MZToastPosition: Int {
    case High
    case Middle
    case Low
    
}

enum MZToastLength: Float {
    case Long
    case Middle
    case Short
}

enum MZDisplayMode: Int {
    case Dark
    case Light
}

class MZToastView: UIView {
    
    
    var contentLabel = UILabel()
    
    //Mark properties on gui
    var widthPercent: CGFloat = 0.85
    var ratio: CGFloat = 6.5
    var lowOffset: CGFloat = 0.82
    var highOffset: CGFloat = 0.14
    var maxAlpha: CGFloat = 0.7
    var showDuration: NSTimeInterval = 0.4
    var dismissDuration: NSTimeInterval = 0.6
    
    var mzPosition: MZToastPosition
    var mzLength: MZToastLength
    var mzDisplayMode: MZDisplayMode
    
    //Mark init
    override init(frame: CGRect) {
        mzPosition = .Middle
        mzLength = .Short
        mzDisplayMode = .Dark
        super.init(frame: frame)
    }
    
    func configure(superView: UIView, content: String, position: MZToastPosition, length: MZToastLength, lightMode: MZDisplayMode) -> MZToastView {
        superView.addSubview(self)
        mzPosition = position
        mzLength = length
        mzDisplayMode = lightMode
        let screenBounds = UIScreen.mainScreen().bounds
        switch lightMode {
        case .Dark:
            self.backgroundColor = UIColor.darkGrayColor()
            break
        case .Light:
            self.backgroundColor = UIColor.lightGrayColor()
            break
        }
        
        let midX = screenBounds.width / 2
        let midY = screenBounds.height / 2
        let toastWidth = screenBounds.width * widthPercent
        self.layer.cornerRadius = toastWidth / 50
        self.layer.masksToBounds = true
        self.alpha = 0
        let toastHeight = toastWidth / ratio
        let startX = midX - toastWidth / 2
        var startY: CGFloat = 0
        var frame: CGRect
        switch position {
        case .High:
            startY = screenBounds.height * highOffset
            break
        case .Middle:
            startY = midY - toastHeight / 2
            break
        case .Low:
            startY = screenBounds.height * lowOffset
            break
        }
        frame = CGRect(x: startX, y: startY, width: toastWidth, height: toastHeight)
        self.frame = frame
        return configLabel(content, lightMode: lightMode)
    }
    
    
    private func configLabel(content: String, lightMode: MZDisplayMode) -> MZToastView {
        self.addSubview(contentLabel)
        contentLabel.text = content
        contentLabel.textAlignment = .Center
        contentLabel.font = UIFont(name: "Avenir Next", size: 14)
        switch lightMode {
        case .Dark:
            contentLabel.textColor = UIColor.whiteColor()
            break
        case .Light:
            contentLabel.textColor = UIColor.blackColor()
            break
        }
        contentLabel.alpha = 1
        if let labelSuperView = contentLabel.superview {
            contentLabel.frame = CGRect(x: 0, y: 0, width: labelSuperView.frame.width, height: labelSuperView.frame.height)
        }
        return self
    }
    
    private func startTimeInterval(length: MZToastLength) {
        var timeInterval: NSTimeInterval = 0
        switch length {
        case .Long:
            timeInterval = 5
            break
        case .Middle:
            timeInterval = 3
            break
        case .Short:
            timeInterval = 1
            break
        }
        NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self, selector: "dismissSelf", userInfo: nil, repeats: false)
    }
    
    func show() {
        UIView.animateWithDuration(showDuration, animations: {
            self.alpha = self.maxAlpha
            }, completion: {
            complete in
                if complete {
                    self.startTimeInterval(self.mzLength)
                }
        })
    }
    
    func dismissSelf(withDuration duration: NSTimeInterval) {
        UIView.animateWithDuration(duration, animations: {
            self.alpha = 0.0
            }) {
                complete in
                if complete {
                    self.removeFromSuperview()
                }
        }
    }

    func dismissSelf() {
        UIView.animateWithDuration(dismissDuration, animations: {
            self.alpha = 0.0
            }) {
                complete in
                if complete {
                    self.removeFromSuperview()
                }
        }
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("touchesBegan")
        dismissSelf(withDuration: dismissDuration / 3)
    }
    
}
