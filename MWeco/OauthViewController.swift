//
//  OauthViewController.swift
//  MWeco
//
//  Created by Monzy on 15/11/19.
//  Copyright © 2015年 Monzy. All rights reserved.
//

import UIKit
import Alamofire

class OauthViewController: UIViewController, UIWebViewDelegate {
    
    // Mark outlets
    @IBOutlet var webView: UIWebView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        webView.loadRequest(NSURLRequest(URL: NSURL(string: BaseURL.kOauthURL)!))
        // Do any additional setup after loading the view.
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let url = request.URL {
            if url.absoluteString.hasPrefix(BaseURL.kRedirectURL) {
                print("get redirect: \(url.queryDictionary())")
                let code = url.queryDictionary()["code"] ?? ""
                if code == "" {
                    self.navigationController?.dismissViewControllerAnimated(true, completion: {
                        print("[oauth cancelled]")
                    })
                    return true
                } else {
                    self.navigationController?.dismissViewControllerAnimated(true, completion: {
                        NetWork.getAccess_Token(code)
                    })
                    return true
                }
            } else {
                print("url not redirected: \(url.queryDictionary())")
                return true
            }
        } else {
            print("urlString get failed")
            return true
        }
    }
}

extension NSURL {
    func queryDictionary() -> [String:String] {
        let queries = self.query?.componentsSeparatedByString("&")
        var queryDic = [String: String]()
        for query in queries ?? [] {
            let pair = query.componentsSeparatedByString("=") ?? []
            queryDic[pair.first ?? ""] = pair.last ?? ""
        }
        return queryDic
    }
}
