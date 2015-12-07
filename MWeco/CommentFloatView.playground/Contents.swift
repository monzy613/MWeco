//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let screenWidth: CGFloat = 375

let width = screenWidth
let height = screenWidth * 0.4

let baseView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
baseView.backgroundColor = UIColor(hex6: 0xebebeb)

//textField
let cfHeight: CGFloat = 30
let cfWidth: CGFloat = width - 20
let commentField = UITextField(frame: CGRect(x: 10, y: height - 10 - cfHeight, width: cfWidth, height: cfHeight))
commentField.borderStyle = .RoundedRect
baseView.addSubview(commentField)
baseView

//dismiss button
let dismissBtn = UIButton()
dismissBtn.backgroundColor = UIColor.blackColor()
baseView.addSubview(dismissBtn)
baseView.addConstraints([
    NSLayoutConstraint(item: dismissBtn, attribute: .Top, relatedBy: .Equal, toItem: baseView, attribute: .Top, multiplier: 1, constant: 10),
    NSLayoutConstraint(item: dismissBtn, attribute: .Leading, relatedBy: .Equal, toItem: baseView, attribute: .Leading, multiplier: 1, constant: 10),
    NSLayoutConstraint(item: dismissBtn, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: 48),
    NSLayoutConstraint(item: dismissBtn, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: 48)
    ])
baseView