//
//  MZLoadingView.swift
//  MWeco
//
//  Created by Monzy on 15/11/23.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

class MZLoadingView: UIVisualEffectView {
    var spinner: UIActivityIndicatorView?
    let width: CGFloat = 48
    let height: CGFloat = 48
    
    
    init(rootView: UIView, effect: UIVisualEffect?) {
        super.init(effect: effect)
        self.frame = CGRect(x: rootView.frame.midX - width / 2, y: rootView.frame.midY - height / 2, width: width, height: height)
        self.layer.cornerRadius = width / 10
        self.clipsToBounds = true
        rootView.addSubview(self)
        initSpinner()
    }
    
    
    private func initSpinner() {
        spinner = UIActivityIndicatorView()
        spinner?.frame = CGRect(x: 0, y: 0, width: width, height: height)
        self.contentView.addSubview(spinner!)
        self.alpha = 0
    }
    
    func start() {
        UIView.animateWithDuration(0.25, animations: {
            [unowned self] in
            self.alpha = 1.0
        })
        spinner?.startAnimating()
    }
    
    func isAnimating() -> Bool {
        return spinner?.isAnimating() ?? false
    }
    
    func stop() {
        UIView.animateWithDuration(0.25, animations: {
            [unowned self] in
            self.alpha = 0.0
            })
        
        self.spinner?.stopAnimating()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
