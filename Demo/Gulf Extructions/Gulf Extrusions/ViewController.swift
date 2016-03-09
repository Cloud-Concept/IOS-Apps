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
        retrieveCookies()
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
    
    func saveCookies(){
        let defaults = NSUserDefaults.standardUserDefaults()
        let cookiesData = NSKeyedArchiver.archivedDataWithRootObject(NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies!)
        
        defaults.setObject(cookiesData, forKey: "cookies")
        defaults.synchronize()
    }
    func deleteCookies(){
        NSUserDefaults.standardUserDefaults().removeObjectForKey("cookies")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    func retrieveCookies(){
        if (NSUserDefaults.standardUserDefaults().objectForKey("cookies") != nil)
        {
            let cookies = NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().objectForKey("cookies") as! NSData) as! NSArray
            let cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
            for cookie in cookies
            {
                cookieStorage.setCookie(cookie as! NSHTTPCookie)
            }
        }
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
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
        saveCookies()
    }
}

