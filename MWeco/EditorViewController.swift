//
//  EditorViewController.swift
//  MWeco
//
//  Created by Monzy on 15/11/27.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

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
    
    
    // Mark lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    func initUI() {
        //textView
        sendButton.enabled = false
        statusTextView.delegate = self
        statusTextView.text = Constants.newStatusPlaceholder
        statusTextView.textColor = UIColor.lightGrayColor()
    }
    
    // actions
    @IBAction func sendStatus(sender: UIBarButtonItem) {
        self.view.endEditing(true)
        NetWork.uploadTextStatus(statusTextView.text)
        dismissSelf()
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.view.endEditing(true)
        if isEmpty() == true {
            dismissSelf()
        }
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
        isReturnFromEditVC = true
        self.navigationController?.dismissViewControllerAnimated(true, completion: {})
    }
    
    //UITextViewDelegate
    func textViewDidChange(textView: UITextView) {
        if statusTextView.text == "" {
            statusTextView.text = Constants.newStatusPlaceholder
            statusTextView.textColor = UIColor.lightGrayColor()
            sendButton.enabled = false
        } else if isEmpty() {
            changeToBlackText()
        }
    }
    
    private func changeToBlackText() {
        if let originColor = statusTextView.textColor {
            if originColor == UIColor.lightGrayColor() {
                statusTextView.text = ""
                statusTextView.textColor = UIColor.blackColor()
                sendButton.enabled = true
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
    
}
