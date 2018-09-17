//
//  AppDelegate.swift
//  ebanjia
//
//  Created by Chris on 2018/7/31.
//  Copyright © 2018年 ebanjia. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, BMKGeneralDelegate {

    var window: UIWindow?
    var _mapManager: BMKMapManager?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        initBaiduMap()
        
        var isLogin = false
        if let _ = UserDefaults.standard.string(forKey: "token") {
            isLogin = true
        }
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let rootVC: UIViewController!
        
        if isLogin {
            let mainVC = EBMainViewController()
//            mainVC.navigationItem.title = "e搬家"
//            let navi = UINavigationController(rootViewController: mainVC)
//            //导航栏背景颜色
//            navi.navigationBar.barTintColor = UIColor(red: 0, green: 144/255.0, blue: 227/255.0, alpha: 1)
//            let dict:NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18)]
//            //标题颜色
//            navi.navigationBar.titleTextAttributes = dict as? [NSAttributedStringKey : Any]
//            
//            UINavigationBar.appearance().tintColor = UIColor.white
            
            rootVC = mainVC
        }else {
            rootVC =  EBLoginViewController()
        }
        self.window?.rootViewController = rootVC
        self.window?.makeKeyAndVisible()
        
        return true
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
    
    private func initBaiduMap() {
        // 要使用百度地图，请先启动BaiduMapManager
        _mapManager = BMKMapManager()
        /**
         *百度地图SDK所有接口均支持百度坐标（BD09）和国测局坐标（GCJ02），用此方法设置您使用的坐标类型.
         *默认是BD09（BMK_COORDTYPE_BD09LL）坐标.
         *如果需要使用GCJ02坐标，需要设置CoordinateType为：BMK_COORDTYPE_COMMON.
         */
        if BMKMapManager.setCoordinateTypeUsedInBaiduMapSDK(BMK_COORDTYPE_BD09LL) {
            NSLog("经纬度类型设置成功");
        } else {
            NSLog("经纬度类型设置失败");
        }
        // 如果要关注网络及授权验证事件，请设定generalDelegate参数
        let ret = _mapManager?.start("Yuhy5DR6XvLfSYKv7nAfHykkpHyL94oX", generalDelegate: self)
        if ret == false {
            NSLog("manager start failed!")
        }
    }
    
    //MARK: - BMKGeneralDelegate
    func onGetNetworkState(_ iError: Int32) {
        if (0 == iError) {
            NSLog("联网成功");
        }
        else{
            NSLog("联网失败，错误代码：Error\(iError)");
        }
    }
    
    func onGetPermissionState(_ iError: Int32) {
        if (0 == iError) {
            NSLog("授权成功");
        }
        else{
            NSLog("授权失败，错误代码：Error\(iError)");
        }
    }

}

