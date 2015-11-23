//
//  TestViewController.swift
//  MWeco
//
//  Created by Monzy on 15/11/23.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    var loadingView: MZLoadingView?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadingView = MZLoadingView(rootView: view, effect: UIBlurEffect(style: .Light))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var isLoading = false
    @IBAction func startAndStop(sender: UIButton) {
        if isLoading == false {
            loadingView!.start()
            isLoading = true
        } else {
            loadingView!.stop()
            isLoading = false
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
