//
//  AppDelegate.swift
//  heibaiyu
//
//  Created by jiwei.wang on 1/17/17.
//  Copyright © 2017 yijian. All rights reserved.
//

import UIKit
import Whisper
import SwiftyBeaver
import SwiftyTimer
import Reachability
let blog = SwiftyBeaver.self


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  var netyi_ts: Int = 0
#if DEBUG
  let pingtime: Int = 15
#else
  let pingtime: Int = 90
#endif
		

  let connectNoti = Notification.Name("client_connect")
  let reachable = Reachability()!

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // log
    let console = ConsoleDestination()  // log to Xcode Console
    let file = FileDestination()  // log to default swiftybeaver.log file
    let cloud = SBPlatformDestination(appID: "0G8Zdw", appSecret: "fUztpslboizfwDw968gabnktxe4homhx", encryptionKey: "9tPMxajdieYxscqnncnnq6bhxyrpD0ai") // to cloud
    console.format = "$DHH:mm:ss$d $L $M"
    file.format = "$DHH:mm:ss$d $L $M"
    cloud.format = "$DHH:mm:ss$d $L $M"
    blog.addDestination(console)
    blog.addDestination(file)
    blog.addDestination(cloud)
    blog.verbose("blog is ok")
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
    let rootvc = StoryboardScene.Main.instantiateSignupController()
    UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    let barAppearace = UINavigationBar.appearance()
    barAppearace.barTintColor = UIColor(named: .huaqin)
    barAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
    window?.rootViewController = rootvc
    return true
  }
  
  func reachableCheck(note: NSNotification) {
    let reachability = note.object as! Reachability
    if reachability.isReachable {
      // netyi config
      NotificationCenter.default.addObserver(self, selector: #selector(pingpong), name: self.connectNoti, object: nil)
      var mainpath = Bundle.main.bundlePath
      mainpath.append("/root-ca.crt")
      let isAlreadyConnected = netyiwarpper.openyi_netWithcert(mainpath, with: {
        NotificationCenter.default.post(name: self.connectNoti, object: nil, userInfo:nil)
      }) { (err_no, err_msg) in
        blog.debug((err_no, err_msg))
        if (60010 != err_no) {
          netyiwarpper.closeyi_net()
          // restart net reachable
          reachability.stopNotifier()
          do {
            try self.reachable.startNotifier()
          } catch {
            blog.debug(error)
          }
        }
      }
      if isAlreadyConnected {
        NotificationCenter.default.post(name: self.connectNoti, object: nil, userInfo:nil)
      }
      netyiwarpper.netyi_net_isConnect(true)
      //
      if reachability.isReachableViaWiFi {
        blog.debug("Reachable via WiFi")
      } else {
        blog.debug("Reachable via Cellular")
      }
    } else {
      netyiwarpper.netyi_net_isConnect(false)
      blog.debug("Network not reachable")
    }
  }
  
  func pingpong() {
    netyi_ts = netyiwarpper.netyi_ts()
    let now_ts = Date().timeIntervalSince1970
    let diff_ts = now_ts - Double(netyi_ts)
    var send_ts = DispatchTime.now()
    
    if diff_ts > Double(pingtime - 5) {
      send_ts = DispatchTime.now() + DispatchTimeInterval.seconds(pingtime)
      var ping = Chat_Ping()
      ping.msg = "ping"
      do {
        let data = try ping.serializeProtobuf()
        netyiwarpper.netyi_ping(String(data: data, encoding: .utf8)!)
      } catch {
        blog.debug(error)
      }
    }else {
      send_ts = DispatchTime.now() + DispatchTimeInterval.seconds(pingtime) - DispatchTimeInterval.fromSeconds(diff_ts)
    }
    DispatchQueue.main.asyncAfter(deadline: send_ts) {
      self.pingpong()
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
    netyiwarpper.closeyi_net()
  }


}

