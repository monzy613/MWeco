//
//  NewStatusMenuViewController.swift
//  MWeco
//
//  Created by Monzy on 15/11/27.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit
import CoreGraphics

class NewStatusMenuViewController: UIViewController {
    
    
    @IBOutlet var textStatusButton: DesignableButton!
    @IBOutlet var imageVideoStatusButton: DesignableButton!
    @IBOutlet var longStatusButton: DesignableButton!
    @IBOutlet var signInButton: DesignableButton!
    @IBOutlet var commentButton: DesignableButton!
    @IBOutlet var moreButton: DesignableButton!
    @IBOutlet var dismissButton: UIButton!
    
    
    @IBOutlet var textStatusLabel: DesignableLabel!
    @IBOutlet var imageStatusLabel: DesignableLabel!
    @IBOutlet var longStatusLabel: DesignableLabel!
    @IBOutlet var signInLabel: DesignableLabel!
    @IBOutlet var commentLabel: DesignableLabel!
    @IBOutlet var moreLabel: DesignableLabel!
    @IBOutlet var tickAndCrossButton: DesignableButton!
    
    @IBOutlet var bottomView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        if isReturnFromEditVC {
            print("isReturnFromEditVC")
            for subview in view.subviews {
                subview.removeFromSuperview()
            }
            performSegueWithIdentifier(Segues.Return, sender: self)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        
    }
    
    
    // actions
    @IBAction func newTextStatus(sender: DesignableButton) {
        dismissButton.enabled = false
        textStatusButton.animation = "pop"
        textStatusButton.animate()
        performSegueWithIdentifier(Segues.NewStatus, sender: self)
    }
    
    
    func initUI() {
        initRoundButton(textStatusButton)
        initRoundButton(imageVideoStatusButton)
        initRoundButton(longStatusButton)
        initRoundButton(signInButton)
        initRoundButton(commentButton)
        initRoundButton(moreButton)
        NSTimer.scheduledTimerWithTimeInterval(0.06, target: self, selector: "rotate", userInfo: nil, repeats: false)
    }
    
    func rotate() {
        rotate(view: tickAndCrossButton, withRadius: CGFloat(0.25 * M_PI), andDuration: 0.2)
    }
    
    func rotate(view rview: UIView, withRadius radius: CGFloat, andDuration duration: NSTimeInterval) {
        UIView.animateWithDuration(duration, animations: {
            rview.transform = CGAffineTransformMakeRotation(radius)
        })
    }
    
    func initRoundButton(button: DesignableButton) {
        button.layer.cornerRadius = UIScreen.mainScreen().bounds.width * 0.2 * 0.5
        button.clipsToBounds = true
    }
    
    @IBAction func dismissButtonPressed(sender: UIButton) {
        dismissButton.enabled = false
        NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: "dismissSelf", userInfo: nil, repeats: false)
        fallComponents()
    }
    
    func dismissSelf() {
        dismissViewControllerAnimated(true, completion: {})
    }
    
    func fallComponents() {
        let lastDelay: CGFloat = 0.1
        let middleDelay: CGFloat = 0.05
        rotate(view: tickAndCrossButton, withRadius: 0, andDuration: 0.3)
        fall(component: longStatusButton, withDuration: 0)
        fall(component: longStatusLabel, withDuration: 0)
        fall(component: moreButton, withDuration: 0)
        fall(component: moreLabel, withDuration: 0)
        
        fall(component: imageVideoStatusButton, withDuration: middleDelay)
        fall(component: imageStatusLabel, withDuration: middleDelay)
        fall(component: commentButton, withDuration: middleDelay)
        fall(component: commentLabel, withDuration: middleDelay)
        
        fall(component: textStatusButton, withDuration: lastDelay)
        fall(component: textStatusLabel, withDuration: lastDelay)
        fall(component: signInButton, withDuration: lastDelay)
        fall(component: signInLabel, withDuration: lastDelay)
    }
    
    func fall(component component: Springable, withDuration duration: CGFloat) {
        component.animation = "fall"
        component.force = 0.8
        component.delay = duration
        component.animate()
    }
}
