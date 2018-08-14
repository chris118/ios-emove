//
//  EBKanjiaViewController.swift
//  ebanjia
//
//  Created by Chris on 2018/8/14.
//  Copyright © 2018年 ebanjia. All rights reserved.
//

import UIKit
import WebKit

class EBKanjiaViewController: UIViewController {
    var orderId: Int?
    @IBOutlet weak var webview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let _orderId = orderId {
            print("https://www.ebanjia.cn/cut/\(_orderId)")
            webview.load(URLRequest(url: URL(string: "https://www.ebanjia.cn/cut/\(_orderId)")!))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
