//
//  EditorViewController.swift
//  MWeco
//
//  Created by Monzy on 15/11/27.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit
import pop

class EditorViewController: UIViewController, UITextViewDelegate {

    // Mark outlets
    @IBOutlet var sendButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var statusTextView: UITextView!
    
    //toolbar and its items
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var imageButton: UIBarButtonItem!
    @IBOutlet var atButton: UIBarButtonItem!
    @IBOutlet var topicButton: UIBarButtonItem!
    @IBOutlet var emojiButton: UIBarButtonItem!
    @IBOutlet var moreButton: UIBarButtonItem!
    
    
    // retweet status
    var retweetStatus: Status?
    var hasRetweetStatus = false
    @IBOutlet var retweetView: UIView!
    @IBOutlet var retweetImageView: AsyncImageView!
    @IBOutlet var retweetScreenNameLabel: UILabel!
    @IBOutlet var retweetStatusTextLabel: UILabel!
    
    var keyboardDownConstraint: NSLayoutConstraint?
    var placeHolder: String = Constants.newStatusPlaceholder
    
    // Mark lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initRetweetView()
        initObservers()
    }
    
    func initUI() {
        //textView
        sendButton.enabled = false
        statusTextView.delegate = self
        statusTextView.text = placeHolder
        statusTextView.textColor = UIColor.lightGrayColor()
        keyboardDownConstraint = NSLayoutConstraint(item: self.view, attribute: .Bottom, relatedBy: .Equal, toItem: toolbar, attribute: .Bottom, multiplier: 1, constant: 0)
        self.view.addConstraint(keyboardDownConstraint!)
    }
    
    
    func initRetweetView() {
        if hasRetweetStatus == false {
            retweetView.removeFromSuperview()
        } else {
            retweetImageView.clipsToBounds = true
            if let status = retweetStatus {
                guard let blogger = status.blogger else {return}
                if status.hasRetweet {
                    guard let rStatus = status.retweeted_status else {return}
                    statusTextView.text = "//@\(blogger.screen_name ?? ""):\(status.text ?? "")"
                    statusTextView.textColor = UIColor.blackColor()
                    if statusTextView.text != "" {
                        sendButton.enabled = true
                    }
                    configureRetweetView(WithStatus: rStatus)
                } else {
                    configureRetweetView(WithStatus: status)
                }
            }
        }
    }
    
    func configureRetweetView(WithStatus status: Status) {
        guard let blogger = status.blogger else {return}
        if status.hasPictures {
            retweetImageView.setURL(status.pic_urls[0].bmiddleURL, placeholderImage: UIImage(named: "guapi"))
        } else {
            retweetImageView.setURL(blogger.avatar_largeURL, placeholderImage: UIImage(named: "guapi"))
        }
        retweetScreenNameLabel.text = "@\(blogger.screen_name ?? "")"
        retweetStatusTextLabel.text = "\(status.text ?? "")"
    }
    
    func initObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // keyboard actions
    func keyboardWillShow(notification: NSNotification) {
        view.bringSubviewToFront(toolbar)
        let keyboardFrame = self.view.convertRect((notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue(), fromView: nil)
        let startPoint = keyboardFrame.origin
        //bounceMove(toolbar, destPoint: startPoint)
        toolbar.frame.origin = startPoint
        let contains = self.view.constraints.contains(keyboardDownConstraint!)
        print("keyboardWillShow, keyboardFrame: \(keyboardFrame), contains: \(contains)")
        UIView.animateWithDuration(0.25, animations: {
            [unowned self] in
            self.keyboardDownConstraint!.constant = keyboardFrame.height
        })
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(1, animations: {
            [unowned self] in
            self.keyboardDownConstraint?.constant = 0
        })
    }
    
    func bounceMove(animationObject: AnyObject, destPoint: CGPoint) {
        let anim = POPSpringAnimation(propertyNamed: kPOPViewCenter)
        anim.springBounciness = 10
        anim.springSpeed = 7
        anim.toValue = NSValue(CGPoint: destPoint)
        animationObject.pop_addAnimation(anim, forKey: "bounceMove")
    }
    
    // actions
    @IBAction func sendStatus(sender: UIBarButtonItem) {
        self.view.endEditing(true)
        if hasRetweetStatus {
            let text = isEmpty() ?"":statusTextView.text
            NetWork.repost(originStatusID: retweetStatus!.id! ?? 0, withText: text)
        } else {
            NetWork.uploadTextStatus(statusTextView.text)
        }
        dismissSelf()
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.view.endEditing(true)
        if isEmpty() == true {
            
        }
        dismissSelf()
    }
    
    @IBAction func addImage(sender: UIBarButtonItem) {
    }
    
    @IBAction func atSomeone(sender: UIBarButtonItem) {
    }
    
    @IBAction func addTopic(sender: UIBarButtonItem) {
    }
    
    @IBAction func addEmoji(sender: UIBarButtonItem) {
    }
    
    @IBAction func showMoreOptions(sender: UIBarButtonItem) {
    }
    
    func dismissSelf() {
        print("shouldDismiss")
        isReturnFromEditVC = true
        self.navigationController?.dismissViewControllerAnimated(true, completion: {})
    }
    
    //UITextViewDelegate
    func textViewDidChange(textView: UITextView) {
        
        if statusTextView.text == "" {
            statusTextView.text = placeHolder
            statusTextView.textColor = UIColor.lightGrayColor()
            sendButton.enabled = false
        } else if isEmpty() {
            changeToBlackText()
        } else {
            sendButton.enabled = true
        }
        
    }
    
    
    private func changeToBlackText() {
        if let originColor = statusTextView.textColor {
            if originColor == UIColor.lightGrayColor() {
                statusTextView.text = ""
                statusTextView.textColor = UIColor.blackColor()
                sendButton.enabled = false
            }
        }
    }
    
    private func isEmpty() -> Bool {
        if let textColor = statusTextView.textColor {
            if textColor == UIColor.lightGrayColor() {
                return true
            } else {
                return false
            }
        } else {
            return true
        }
    }
    
    @IBAction func panGestureDidTriggerred(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Ended:
            if sender.translationInView(statusTextView).y > 0 {
                self.view.endEditing(true)
            }
        default:
            break
        }
    }
    
}
