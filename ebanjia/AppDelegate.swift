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
    var backgroundTask:UIBackgroundTaskIdentifier! = nil
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        initBaiduMap()
        initShareSDK()
        Bugly.start(withAppId: "35bbd1d275")
        
        var isLogin = false
        if let _ = UserDefaults.standard.string(forKey: "token") {
            isLogin = true
        }
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let rootVC: UIViewController!
        
        if isLogin {
            let mainVC = EBMainViewController()
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
        if self.backgroundTask != nil {
            application.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = UIBackgroundTaskInvalid
        }
        self.backgroundTask = application.beginBackgroundTask(expirationHandler: {
            () -> Void in
            //如果没有调用endBackgroundTask，时间耗尽时应用程序将被终止
            application.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = UIBackgroundTaskInvalid
        })
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
    
    //
    func initShareSDK() {
        /**
         *  初始化ShareSDK应用
         *
         *  @param activePlatforms          使用的分享平台集合，如:@[@(SSDKPlatformTypeSinaWeibo), @(SSDKPlatformTypeTencentWeibo)];
         *  @param importHandler           导入回调处理，当某个平台的功能需要依赖原平台提供的SDK支持时，需要在此方法中对原平台SDK进行导入操作。具体的导入方式可以参考ShareSDKConnector.framework中所提供的方法。
         *  @param configurationHandler     配置回调处理，在此方法中根据设置的platformType来填充应用配置信息
         */
        ShareSDK.registerActivePlatforms(
            [
                SSDKPlatformType.typeWechat.rawValue,
            ],
            onImport: {(platform : SSDKPlatformType) -> Void in
                switch platform
                {
                case SSDKPlatformType.typeWechat:
                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                default:
                    break
                }
        },
            onConfiguration: {(platform : SSDKPlatformType , appInfo : NSMutableDictionary?) -> Void in
                switch platform
                {
                case SSDKPlatformType.typeWechat:
                    //设置微信应用信息
                    appInfo?.ssdkSetupWeChat(byAppId: "wx57d8abaf6729936a",
                                             appSecret: "0b40c8e27c528fd8b66f0476bfa12bc4")
                default:
                    break
                }
        })
    }
}

