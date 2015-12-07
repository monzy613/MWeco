//
//  PopAnimations.swift
//  MWeco
//
//  Created by 张逸 on 15/12/7.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit
import pop

func bounceMove(animationObject: AnyObject, destPoint: CGPoint) {
    let anim = POPSpringAnimation(propertyNamed: kPOPViewCenter)
    anim.springBounciness = 10
    anim.springSpeed = 7
    anim.toValue = NSValue(CGPoint: destPoint)
    animationObject.pop_addAnimation(anim, forKey: "bounceMove")
}

func move(animationView: UIView, destPoint: CGPoint) {
    let frame = animationView.frame
    UIView.animateWithDuration(0.35, animations: {
        animationView.frame.origin = CGPoint(x: destPoint.x - frame.width / 2, y: destPoint.y - frame.height / 2)
    })
}