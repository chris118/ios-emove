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
        initUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initUI() {
        let  homeVC  = EBHomeViewController()
        homeVC.title = "首页"
        homeVC.tabBarItem.title = "首页"
        homeVC.tabBarItem.image = UIImage(named:"home_1")
        homeVC.tabBarItem.selectedImage = UIImage(named:"home")
        
        let  infoVC  = EBInfoViewController()
        infoVC.title = "预约搬家"
        let MainNav = UINavigationController(rootViewController:infoVC)
        infoVC.tabBarItem.title = "预约搬家"
        infoVC.tabBarItem.image = UIImage(named:"form_1")
        infoVC.tabBarItem.selectedImage = UIImage(named:"form")
        
        let  orderListVC  = EBOrderListViewController()
        orderListVC.title = "我的订单"
        orderListVC.tabBarItem.title = "我的订单"
        orderListVC.tabBarItem.image = UIImage(named:"order_1")
        orderListVC.tabBarItem.selectedImage = UIImage(named:"order")
        
        self.viewControllers = [homeVC,infoVC,orderListVC]
    }
}
