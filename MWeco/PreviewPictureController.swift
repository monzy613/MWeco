//
//  PreviewPictureController.swift
//  MWeco
//
//  Created by Monzy on 15/11/26.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit

class PreviewPictureController: UIViewController {

    var imageURL: NSURL?
    
    @IBOutlet var imageViewToPreview: AsyncImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = imageURL {
            self.imageViewToPreview.url = url
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
