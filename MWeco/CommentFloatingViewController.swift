//
//  CommentFloatingViewController.swift
//  MWeco
//
//  Created by 张逸 on 15/12/7.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

class CommentFloatingViewController: UIViewController {
    
    var tbController: TabBarController?
    var statusId: Int64?
    @IBOutlet weak var commentView: SpringView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var sendButton: SpringButton!
    @IBOutlet weak var commentTextField: UITextField!
    
    var alsoRetweet = false
    
    var commentViewBottomConstraint: NSLayoutConstraint?

    @IBAction func checkBoxPressed(sender: UIButton) {
        if alsoRetweet == false {
            UIView.animateWithDuration(0.15, animations: {
                [unowned self] in
                self.checkBox.backgroundColor = UIColor(hex6: 0x0079FF)
            })
        } else {
            UIView.animateWithDuration(0.15, animations: {
                [unowned self] in
                self.checkBox.backgroundColor = UIColor.whiteColor()
                })
        }
        alsoRetweet = (!alsoRetweet)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initObservers()
        toggleKeyboard()
    }
    
    func toggleKeyboard() {
        commentTextField.becomeFirstResponder()
    }
    
    func initObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func initUI() {
        checkBox.layer.cornerRadius = checkBox.frame.width / 10
        checkBox.setImage(UIImage(named: ImageNames.tick_white), forState: .Normal)
        checkBox.tintColor = UIColor.whiteColor()
        sendButton.layer.cornerRadius = sendButton.frame.height / 8
        
        commentViewBottomConstraint = NSLayoutConstraint(item: view, attribute: .Bottom, relatedBy: .Equal, toItem: commentView, attribute: .Bottom, multiplier: 1, constant: 0)
        view.addConstraint(commentViewBottomConstraint!)
    }
    
    // keyboard actions
    func keyboardWillShow(notification: NSNotification) {
        let keyboardFrame = view.convertRect((notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue(), fromView: nil)
        UIView.animateWithDuration(0.25, animations: {
            [unowned self] in
            self.commentViewBottomConstraint!.constant = keyboardFrame.height
        })
    }
    
    @IBAction func dismissButtonPressed(sender: UIButton) {
        view.endEditing(true)
        bounceMove(commentView, destPoint: CGPoint(x: commentView.frame.midX, y: UIScreen.mainScreen().bounds.height - commentView.frame.height / 2))
        NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "dismissSelf", userInfo: nil, repeats: false)
    }
    
    @IBAction func sendButtonPressed(sender: SpringButton) {
        guard let comment = commentTextField.text else {return}
        if comment != "" && statusId != nil {
            view.endEditing(true)
            NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
            commentTextField.text = ""
            NetWork.commentOnStatus(withId: statusId!, comment_ori: 0, comment: comment)
            dismissButtonPressed(sender)
        } else {
        }
    }
    
    func dismissSelf() {
        dismissViewControllerAnimated(true, completion: {})
        self.tbController?.showTabbar()
    }
    
    
}
