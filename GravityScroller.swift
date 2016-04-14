//
//  GravityScroller.swift
//  CoreMotionTest
//
//  Created by 张逸 on 15/12/8.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit
import CoreMotion



class GravityScroller: AnyObject {
    enum Direction: CGFloat {
        case Normal = 1
        case UpsideDown = -1
    }
    
    static var speed: CGFloat = 0.8 {
        didSet {
            if speed > 1 {
                speed = 1
            } else if speed <= 0 {
                stop()
            }
        }
    }
    static var stableAmount: CGFloat = 0.07
    static var originAccelerationY: CGFloat?
    static var baseOffsetY: CGFloat?
    static var motionManager: CMMotionManager!
    static var tableView: UITableView!
    static var isPause = false
    static var direction: Direction!
    
    static var bottomOffsetMaxHeight: CGFloat = 0
    
    static func initAccelerometer(withTableView _tableView: UITableView, andMotionManager _motionManager: CMMotionManager, withDirection _direction: Direction = .Normal) {
        tableView = _tableView
        motionManager = _motionManager
        direction = _direction
    }
    
    static func start(onTop onTop: Void -> Void, onBottom: Void -> Void) {
        if tableView == nil || motionManager == nil {
            return
        }
        if motionManager.accelerometerAvailable {
            print("active")
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()) {
                data, error in
                if isPause {
                    return
                }
                var pre: CGFloat = 1
                var accelerationY = CGFloat((data?.acceleration.y)!)
                if originAccelerationY == nil {
                    print("offsetY: \(tableView.contentOffset.y)")
                    baseOffsetY = tableView.contentOffset.y
                    originAccelerationY = accelerationY
                }
                accelerationY = accelerationY - originAccelerationY!
                if accelerationY > 0 {
                    pre = 1
                } else if accelerationY < 0 {
                    pre = -1
                }
                pre = pre * (direction.rawValue)
                
                if abs(accelerationY) < stableAmount {
                    return
                }
                accelerationY = (abs(accelerationY) - stableAmount)
                //up to -1, down to 1, plain to 0
                
                let offsetY = accelerationY * accelerationY * pre * tableView.frame.height * speed
                
                if (tableView.contentOffset.y + offsetY) < baseOffsetY! {
                    onTop()
                    UIView.animateWithDuration(0.1, animations: {
                        tableView.contentOffset = CGPoint(x: tableView.contentOffset.x, y: baseOffsetY!)
                    })
                } else if (tableView.contentOffset.y + offsetY) > (tableView.contentSize.height - tableView.bounds.height) {
                    onBottom()
                    UIView.animateWithDuration(0.1, animations: {
                        tableView.contentOffset = CGPoint(x: tableView.contentOffset.x, y: tableView.contentSize.height - tableView.bounds.height)
                        })
                } else {
                    UIView.animateWithDuration(0.1, animations: {
                        tableView.contentOffset = CGPoint(x: tableView.contentOffset.x, y: offsetY + tableView.contentOffset.y)
                    })
                }
            }
        } else {
            print("not active")
        }
    }
    
    static func stop() {
        baseOffsetY = nil
        originAccelerationY = nil
        tableView = nil
        if motionManager != nil {
            motionManager.stopAccelerometerUpdates()
        }
    }
    
    static func pause() {
        isPause = true
    }
    
    static func play() {
        isPause = false
    }
    
    static func restart() {
        baseOffsetY = nil
        originAccelerationY = nil
        play()
    }
}