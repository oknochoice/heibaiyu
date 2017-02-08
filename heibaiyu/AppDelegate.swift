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
    if leveldb.sharedInstance.getCurrentUserid() != nil {
      rootvc = StoryboardScene.Main.instantiateTabbarController()
    }else {
      rootvc = StoryboardScene.Main.instantiateSigninController()
    }
    UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    let barAppearace = UINavigationBar.appearance()
    barAppearace.barTintColor = UIColor(named: .qincong)
    barAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
    barAppearace.tintColor = UIColor.white
    UITabBar.appearance().tintColor = UIColor(named: .qincong)
    window?.rootViewController = rootvc
    return true
  }
  
  func startNetyi() throws {
    // netyi config
    var mainpath = Bundle.main.bundlePath
    mainpath.append("/root-ca.crt")
    if netyiwarpper.netyi_isOpened() {
      blog.debug("netyi is already open")
    }else {
      var ping = Chat_Ping()
      ping.msg = "ping"
      let data = try ping.serializeProtobuf()
      netyiwarpper.openyi_netWithcert(mainpath, with: data, with: { [weak self] in
        DispatchQueue.main.async { [weak self] in
          NotificationCenter.default.post(name: (self?.connectNoti)!, object: self!, userInfo:nil)
          self!.connect()
        }
      }) {  (err_no, err_msg) in
        DispatchQueue.main.async {
          blog.debug((err_no, err_msg))
          if (60010 != err_no &&
            60012 != err_no) {
            netyiwarpper.closeyi_net();
          }
        }
      }
      netyiwarpper.netyi_net_isConnect(true)
    }
  }
  
  func connect() {
    if let clientConnect = userinfo.getConnect() {
      if let data = try? clientConnect.serializeProtobuf() {
        netyiwarpper.netyi_signup_login_connect(with: ChatType.clientconnect.rawValue, data: data, cb: { (type, data, isStop) in
        DispatchQueue.main.async {
          if ChatType.clientconnectres.Int16Value() == type {
            if let res = try? Chat_ClientConnectRes(protobuf: data) {
              blog.verbose(try! res.serializeAnyJSON())
              if res.isSuccess {
              }else {
                errorLocal.error(err_no: res.eNo, orMsg: res.eMsg)
              }
            }
          }
        }   
        })
      }
    }
  }
  
  func reachableCheck(note: NSNotification) {
    let reachability = note.object as! Reachability
    DispatchQueue.main.async { [weak self] in
      do {
        if reachability.isReachable {
          try self!.startNetyi();
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
      }catch {
        print(error)
      }
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

