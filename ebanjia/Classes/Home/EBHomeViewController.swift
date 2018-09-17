//
//  EBHomeViewController.swift
//  ebanjia
//
//  Created by admin on 2018/8/5.
//  Copyright © 2018年 ebanjia. All rights reserved.
//

import UIKit

class EBHomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    
    @IBAction func goTap(_ sender: Any) {
        self.tabBarController?.selectedIndex = 1
    }
}
