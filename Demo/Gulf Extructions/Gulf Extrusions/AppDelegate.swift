//
//  AppDelegate.swift
//  Global Village Support
//
//  Created by George Hanna Adly on 9/27/15.
//  Copyright (c) 2015 George Hanna Adly. All rights reserved.
//

import UIKit
import SalesforceSDKCore

// Fill these in when creating a new Connected Application on Force.com
//let RemoteAccessConsumerKey = "3MVG9Rd3qC6oMalWCGyAYAPP7x3S2NCYODgk.CCIH_2azXCcb82wJFk5XIm0GNaxTlq9340dPh70zHXHNTIMR";
let RemoteAccessConsumerKey = "3MVG9Rd3qC6oMalXVVq9d89fI0t82BLCMERKZ6gB8jCPldEqJJMraMMXn05ExN32g7t1a3kKIHoqGumHIXIRw";
let OAuthRedirectURI        = "df://test/success";


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    override
    init()
    {
        super.init()
        SFLogger.setLogLevel(.Debug)
        
        SalesforceSDKManager.sharedManager().connectedAppId = RemoteAccessConsumerKey
        SalesforceSDKManager.sharedManager().connectedAppCallbackUri = OAuthRedirectURI
        SalesforceSDKManager.sharedManager().authScopes = ["web", "api"];
        SFLoginViewController.sharedInstance().styleNavigationBar(UINavigationBar(frame:         CGRectMake(0, 0, 100, 45)))
        SalesforceSDKManager.sharedManager().postLaunchAction = {
            [unowned self] (launchActionList: SFSDKLaunchAction) in
            let launchActionString = SalesforceSDKManager.launchActionsStringRepresentation(launchActionList)
            self.log(.Info, msg:"Post-launch: launch actions taken: \(launchActionString)");
            self.setupRootViewController();
        }
        SalesforceSDKManager.sharedManager().launchErrorAction = {
            [unowned self] (error: NSError?, launchActionList: SFSDKLaunchAction) in
            if let actualError = error {
                self.log(.Error, msg:"Error during SDK launch: \(actualError.localizedDescription)")
            } else {
                self.log(.Error, msg:"Unknown error during SDK launch.")
            }
            self.initializeAppViewState()
            SalesforceSDKManager.sharedManager().launch()
        }
        SalesforceSDKManager.sharedManager().postLogoutAction = {
            [unowned self] in
            self.handleSdkManagerLogout()
        }
        SalesforceSDKManager.sharedManager().switchUserAction = {
            [unowned self] (fromUser: SFUserAccount?, toUser: SFUserAccount?) -> () in
            self.handleUserSwitch(fromUser, toUser: toUser)
        }
    }
    
    // MARK: - App delegate lifecycle
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool
    {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
        self.initializeAppViewState();
        
        //
        // If you wish to register for push notifications, uncomment the line below.  Note that,
        // if you want to receive push notifications from Salesforce, you will also need to
        // implement the application:didRegisterForRemoteNotificationsWithDeviceToken: method (below).
        //
        // SFPushNotificationManager.sharedInstance().registerForRemoteNotifications()
        
        SalesforceSDKManager.sharedManager().launch()
        
        return true
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        
//        var cookieProperties = [String: AnyObject]()
//        cookieProperties[NSHTTPCookieName] = "app"
//        cookieProperties[NSHTTPCookieValue] = ""
//        cookieProperties[NSHTTPCookieDomain] = "georgehadly-dev-ed.my.salesforce.com"
//        cookieProperties[NSHTTPCookiePath] = "georgehadly-dev-ed.my.salesforce.com"
////        cookieProperties[NSHTTPCookieVersion] = NSNumber(integer: cookie.version)
//        cookieProperties[NSHTTPCookieExpires] = NSDate().dateByAddingTimeInterval(31536000)
//
//        NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookie(NSHTTPCookie(properties: cookieProperties)!);
    }
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData)
    {
        //
        // Uncomment the code below to register your device token with the push notification manager
        //
        //
        // SFPushNotificationManager.sharedInstance().didRegisterForRemoteNotificationsWithDeviceToken(deviceToken)
        // if (SFAccountManager.sharedInstance().credentials.accessToken != nil)
        // {
        //    SFPushNotificationManager.sharedInstance().registerForSalesforceNotifications()
        // }
    }
    
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError )
    {
        // Respond to any push notification registration errors here.
    }
    
    // MARK: - Private methods
    func initializeAppViewState()
    {
        if (!NSThread.isMainThread()) {
            dispatch_async(dispatch_get_main_queue()) {
                self.initializeAppViewState()
            }
            return
        }
        
        self.window!.rootViewController = InitialViewController(nibName: nil, bundle: nil)
        self.window!.makeKeyAndVisible()
    }
    
    func setupRootViewController()
    {
        
        let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HomeViewController") as! ViewController
//        let navVC = UINavigationController(rootViewController: rootVC)
        self.window!.rootViewController = rootVC
    }
    
    func resetViewState(postResetBlock: () -> ())
    {
        if let rootViewController = self.window!.rootViewController {
            if let _ = rootViewController.presentedViewController {
                rootViewController.dismissViewControllerAnimated(false, completion: postResetBlock)
                return
            }
        }
        
        postResetBlock()
    }
    
    func handleSdkManagerLogout()
    {
        self.log(.Debug, msg: "SFAuthenticationManager logged out.  Resetting app.")
        self.resetViewState { () -> () in
            self.initializeAppViewState()
            
            // Multi-user pattern:
            // - If there are two or more existing accounts after logout, let the user choose the account
            //   to switch to.
            // - If there is one existing account, automatically switch to that account.
            // - If there are no further authenticated accounts, present the login screen.
            //
            // Alternatively, you could just go straight to re-initializing your app state, if you know
            // your app does not support multiple accounts.  The logic below will work either way.
            
            var numberOfAccounts : Int;
            let allAccounts = SFUserAccountManager.sharedInstance().allUserAccounts as! [SFUserAccount]?
            if allAccounts != nil {
                numberOfAccounts = allAccounts!.count;
            } else {
                numberOfAccounts = 0;
            }
            
            if numberOfAccounts > 1 {
                let userSwitchVc = SFDefaultUserManagementViewController(completionBlock: {
                    action in
                    self.window!.rootViewController!.dismissViewControllerAnimated(true, completion: nil)
                })
                self.window!.rootViewController!.presentViewController(userSwitchVc, animated: true, completion: nil)
            } else {
                if (numberOfAccounts == 1) {
                    SFUserAccountManager.sharedInstance().currentUser = allAccounts![0]
                }
                SalesforceSDKManager.sharedManager().launch()
            }
        }
    }
    
    func handleUserSwitch(fromUser: SFUserAccount?, toUser: SFUserAccount?)
    {
        let fromUserName = (fromUser != nil) ? fromUser?.userName : "<none>"
        let toUserName = (toUser != nil) ? toUser?.userName : "<none>"
        self.log(.Debug, msg:"SFUserAccountManager changed from user \(fromUserName) to \(toUserName).  Resetting app.")
        self.resetViewState { () -> () in
            self.initializeAppViewState()
            SalesforceSDKManager.sharedManager().launch()
        }
    }


}

