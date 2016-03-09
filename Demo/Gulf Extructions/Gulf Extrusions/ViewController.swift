//
//  ViewController.swift
//  Global Village Support
//
//  Created by George Hanna Adly on 9/27/15.
//  Copyright (c) 2015 George Hanna Adly. All rights reserved.
// CloudConcept000

import UIKit
import SalesforceSDKCore


class ViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // https://georgehadly-dev-ed.my.salesforce.com/one/one.app
//        https://dev-gulfextrusions.cs81.force.com
//        NSLog("\(SFUserAccountManager.sharedInstance().currentUser.credentials.instanceUrl)")
        
//        self.webview.delegate = self;
//        [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:frontDoorUrl]]];
//        self.webview.scalesPageToFit = YES;
//        
//         let url = NSURL(string: "\(SFUserAccountManager.sharedInstance().currentUser.credentials.instanceUrl.absoluteString)/secur/frontdoor.jsp?sid=\(SFUserAccountManager.sharedInstance().currentUser.credentials.accessToken)&retURL=one/one.app&display=touch")
let url = NSURL(string: "https://gulfex.force.com/one/one.app")
        
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func shouldAutorotate() -> Bool {
        return false;
    }

    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
         SVProgressHUD.dismiss()
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
        
        
//        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
//        [cookieProperties setObject:name forKey:NSHTTPCookieName];
//        [cookieProperties setObject:strValue forKey:NSHTTPCookieValue];
//        [cookieProperties setObject:@"myserver.com" forKey:NSHTTPCookieDomain];    // Without http://
//        [cookieProperties setObject:@"myserver.com" forKey:NSHTTPCookieOriginURL]; // Without http://
//        [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
//        
//        // set expiration to one month from now or any NSDate of your choosing
//        // this makes the cookie sessionless and it will persist across web sessions and app launches
//        /// if you want the cookie to be destroyed when your app exits, don't set this
//        [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
//        
//        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
//        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        
    }
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true;
    }
    func webViewDidStartLoad(webView: UIWebView) {
        if(!SVProgressHUD.isVisible()){
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
            SVProgressHUD.showWithStatus("Loading ...")
        }
    }

}

