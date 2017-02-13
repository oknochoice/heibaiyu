//
//  AppDelegate.swift
//  heibaiyu
//
//  Created by jiwei.wang on 1/17/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import UIKit
import Whisper
import XCGLogger
import SwiftyTimer
import Reachability
let blog = XCGLogger.default

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  var netyi_ts: Int = 0
		

  let connectNoti = Notification.Name("client_connect")
  let reachable = Reachability()!

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // log
    let blogpath = Bundle.main.resourcePath?.appending("/xcglog")
    //let blogpath = "/Users/jiwei.wang/Desktop/xcglog"
#if DEBUG
    blog.setup(level: .verbose, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: blogpath, fileLevel: .debug)
#else
    blog.setup(level: .none, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: blogpath, fileLevel: .none)
#endif
    /*
    let console = ConsoleDestination()  // log to Xcode Console
    let file = FileDestination()  // log to default swiftybeaver.log file
    let cloud = SBPlatformDestination(appID: "0G8Zdw", appSecret: "fUztpslboizfwDw968gabnktxe4homhx", encryptionKey: "9tPMxajdieYxscqnncnnq6bhxyrpD0ai") // to cloud
    console.format = "$C$F$c$DHH:mm:ss$d $T $L $M$c"
    file.format = "$C$DHH:mm:ss$d $T $L $M$c"
    cloud.format = "$C$DHH:mm:ss$d $T $L $M$c"
    blog.addDestination(console)
    blog.addDestination(file)
    blog.addDestination(cloud)
 */
    blog.verbose("blog path \(blogpath)")
    // bundle language
    Bundle.setLanguage("zh-Hans")
    // net whether reachable
    NotificationCenter.default.addObserver(self, selector: #selector(self.reachableCheck(note:)), name: ReachabilityChangedNotification, object: reachable)
    do {
      try reachable.startNotifier()
    } catch {
      blog.debug(error)
    }
    // root vc
    var rootvc: UIViewController?
    //if leveldb.sharedInstance.getCurrentUserid() != nil {
      rootvc = StoryboardScene.Main.instantiateTabbarController()
    //}else {
      rootvc = StoryboardScene.Main.instantiateSigninController()
    //}
    UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    let barAppearace = UINavigationBar.appearance()
    barAppearace.barTintColor = UIColor(named: .qincong)
    barAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
    barAppearace.tintColor = UIColor.white
    UITabBar.appearance().tintColor = UIColor(named: .qincong)
    window?.rootViewController = rootvc
    return true
  }
  
  
  func reachableCheck(note: NSNotification) {
    let reachability = note.object as! Reachability
    if reachability.isReachable {
      if reachability.isReachableViaWiFi {
        blog.debug("Reachable via WiFi")
      } else {
        blog.debug("Reachable via Cellular")
      }
      netdbwarpper.sharedNetdb().openNet({ (errNo, errMsg) in
        blog.debug((errNo, errMsg));
        if (0 == errNo) {
          DispatchQueue.main.async {[weak self] in
            NotificationCenter.default.post(name: (self?.connectNoti)!, object: self)
          }
        }
      })
      netdbwarpper.sharedNetdb().setNetIsReachable(true);
    }else {
      netdbwarpper.sharedNetdb().setNetIsReachable(false);
    }
  }
 
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

