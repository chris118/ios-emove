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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func goTap(_ sender: Any) {
        self.tabBarController?.selectedIndex = 1
    }
}
