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
        let  homeVC  = EBVehicleViewController()
        homeVC.tabBarItem.title = "首页"
        homeVC.tabBarItem.image = UIImage(named:"home_1")
        homeVC.tabBarItem.selectedImage = UIImage(named:"home")
        
        let  infoVC  = EBInfoViewController()
        let navi = UINavigationController(rootViewController: infoVC)
        //导航栏背景颜色
        navi.navigationBar.barTintColor = UIColor(red: 0, green: 146/255.0, blue: 224/255.0, alpha: 1)
        let dict:NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18)]
        //标题颜色
        navi.navigationBar.titleTextAttributes = dict as? [NSAttributedStringKey : Any]
        UINavigationBar.appearance().tintColor = UIColor.white
        
        navi.tabBarItem.title = "预约搬家"
        navi.tabBarItem.image = UIImage(named:"form_1")
        navi.tabBarItem.selectedImage = UIImage(named:"form")
        
        let  orderListVC  = EBOrderListViewController()
        orderListVC.tabBarItem.title = "我的订单"
        orderListVC.tabBarItem.image = UIImage(named:"order_1")
        orderListVC.tabBarItem.selectedImage = UIImage(named:"order")
        
        self.viewControllers = [homeVC,navi,orderListVC]
    }
}
