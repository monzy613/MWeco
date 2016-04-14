//
//  MZButtonProgressView.swift
//  M_fm
//
//  Created by 张逸 on 16/4/11.
//  Copyright © 2016年 MonzyZhang. All rights reserved.
//

import UIKit
import pop

class MZButtonProgressView: UIButton {
    var endImage: UIImage?
    var progressBarLength: CGFloat = 0.0
    var progressLayer: CAShapeLayer?
    var startedProgress = false

    init(frame: CGRect, progressBarLength: CGFloat = 100.0) {
        super.init(frame: frame)
        self.progressBarLength = progressBarLength
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.magentaColor()
        self.layer.cornerRadius = frame.width / 2
    }
    func transformToPrograssBar() {
        startedProgress = true
        self.setImage(nil, forState: .Normal)

        let newHeight = self.frame.height / 3
        let newCornerRadius = newHeight / 2

        progressLayer = CAShapeLayer()
        progressLayer?.strokeColor = UIColor.whiteColor().CGColor
        progressLayer!.lineCap   = kCALineCapRound
        progressLayer!.lineJoin  = kCALineJoinBevel
        progressLayer!.lineWidth = 7
        progressLayer!.strokeEnd = 0
        let progressLine = UIBezierPath()
        progressLine.moveToPoint(CGPointMake(10, newHeight / 2))
        progressLine.addLineToPoint(CGPointMake(progressBarLength - 10, newHeight / 2))
        progressLayer?.path = progressLine.CGPath

        self.layer.addSublayer(progressLayer!)

        let cornerRadiusAnim = POPSpringAnimation(propertyNamed: kPOPLayerCornerRadius)
        cornerRadiusAnim.springBounciness = 5
        cornerRadiusAnim.springSpeed = 5
        cornerRadiusAnim.toValue = newCornerRadius

        let boundsAnim = POPSpringAnimation(propertyNamed: kPOPLayerBounds)
        boundsAnim.springBounciness = 5
        boundsAnim.springSpeed = 5
        boundsAnim.toValue = NSValue(CGRect: CGRectMake(0, 0, progressBarLength, newHeight))
        boundsAnim.completionBlock = {
            anim, finished in
            if finished {
            }
        }

        self.pop_addAnimation(boundsAnim, forKey: "boundsAnimation")
        self.layer.pop_addAnimation(cornerRadiusAnim, forKey: "cornerRadiusAnim")
    }

    func updateProgress(progress: CGFloat) {
        //print("progress: \(progress * 100)%")
        self.progressLayer!.strokeEnd = progress
        if progress >= 1.0 {
            print("progress complete: \(progress * 100)%")
            self.progressLayer?.removeFromSuperlayer()
            self.setImage(self.endImage, forState: .Normal)
            let newHeight = self.frame.height * 3
            let newCornerRadius = newHeight / 2
            let cornerRadiusAnim = POPSpringAnimation(propertyNamed: kPOPLayerCornerRadius)
            cornerRadiusAnim.springBounciness = 5
            cornerRadiusAnim.springSpeed = 5
            cornerRadiusAnim.toValue = newCornerRadius

            let boundsAnim = POPSpringAnimation(propertyNamed: kPOPLayerBounds)
            boundsAnim.springBounciness = 5
            boundsAnim.springSpeed = 5
            boundsAnim.toValue = NSValue(CGRect: CGRectMake(0, 0, newHeight, newHeight))
            boundsAnim.completionBlock = {
                anim, finished in
                if finished {
                    self.setImage(self.endImage, forState: .Normal)
                    self.setImage(self.endImage, forState: .Highlighted)
                }
            }

            self.pop_addAnimation(boundsAnim, forKey: "boundsAnimation_back")
            self.layer.pop_addAnimation(cornerRadiusAnim, forKey: "cornerRadiusAnim_back")
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
