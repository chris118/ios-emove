//
//  EBMainViewController.swift
//  ebanjia
//
//  Created by admin on 2018/8/5.
//  Copyright © 2018年 ebanjia. All rights reserved.
//

import UIKit

class EBMainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        let  homeVC  = EBHomeViewController()
        homeVC.tabBarItem.title = "首页"
        homeVC.tabBarItem.image = UIImage(named:"home_1")
        homeVC.tabBarItem.selectedImage = UIImage(named:"home")
        
        let  infoVC  = EBInfoViewController()
        let naviHome = UINavigationController(rootViewController: infoVC)
        naviHome.navigationBar.barTintColor = UIColor(red: 0, green: 146/255.0, blue: 224/255.0, alpha: 1)
        let dict:NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18)]
        naviHome.navigationBar.titleTextAttributes = dict as? [NSAttributedStringKey : Any]
        UINavigationBar.appearance().tintColor = UIColor.white
        naviHome.tabBarItem.title = "预约搬家"
        naviHome.tabBarItem.image = UIImage(named:"form_1")
        naviHome.tabBarItem.selectedImage = UIImage(named:"form")
        
        let  orderListVC  = EBOrderListViewController()
        let naviOrderList = UINavigationController(rootViewController: orderListVC)
        naviOrderList.navigationBar.barTintColor = UIColor(red: 0, green: 146/255.0, blue: 224/255.0, alpha: 1)
        naviOrderList.navigationBar.titleTextAttributes = dict as? [NSAttributedStringKey : Any]
        naviOrderList.tabBarItem.title = "我的订单"
        naviOrderList.tabBarItem.image = UIImage(named:"order_1")
        naviOrderList.tabBarItem.selectedImage = UIImage(named:"order")
        
        self.viewControllers = [homeVC,naviHome,naviOrderList]
    }
}
