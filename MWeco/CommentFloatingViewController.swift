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
    }
    
    func initObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // keyboard actions
    func keyboardWillShow(notification: NSNotification) {
    }
    
    func keyboardWillHide(notification: NSNotification) {
    }
    
    @IBAction func dismissButtonPressed(sender: UIButton) {
        UIView.animateWithDuration(0.25, animations: {
            [unowned self] in
            self.commentView.frame.origin = CGPoint(x: 0, y: UIScreen.mainScreen().bounds.height)
            }) {
                complete in
                if complete {
                        self.dismissViewControllerAnimated(true, completion: {})
                }
        }
        tbController?.showTabbar()
    }
    
    @IBAction func sendButtonPressed(sender: SpringButton) {
        guard let comment = commentTextField.text else {return}
        if comment != "" && statusId != nil {
            commentTextField.text = ""
            NetWork.commentOnStatus(withId: statusId!, comment_ori: 0, comment: comment)
        }
    }
    
    func initUI() {
        checkBox.layer.cornerRadius = checkBox.frame.width / 10
        checkBox.setImage(UIImage(named: ImageNames.tick_white), forState: .Normal)
        checkBox.tintColor = UIColor.whiteColor()
        sendButton.layer.cornerRadius = sendButton.frame.height / 2
    }
    
}
