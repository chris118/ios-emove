//
//  EBLoginViewController.swift
//  ebanjia
//
//  Created by Chris on 2018/8/2.
//  Copyright © 2018年 ebanjia. All rights reserved.
//

import UIKit
import Moya
import PKHUD

class EBLoginViewController: UIViewController {
    @IBOutlet weak var codeButton: UIButton!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    
    private var timer:Timer?
    private var counter = 60
    private let serviceProvider = MoyaProvider<EBServiceApi>()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        print("EBLoginViewController deinit")
    }
    
    @IBAction func codeButtonTap(_ sender: Any) {
        guard let mobile = mobileTextField.text, mobile.count >= 11 else {
            HUD.flash(.label("请输入正确的手机号码"), delay: 1.0)
            return
        }
        serviceProvider.request(.requestVerifyCode(mobile: mobile)) { (result) in
            switch result {
            case let .success(response):
                do {
                    print(try response.mapString())
                    let resp = EBResponseEmpty(JSONString: try response.mapString())
                    if resp?.code == 0 { // 发送成功 倒计时开始
                        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {[weak self] (timer) in
                            guard let `self` = self else {
                                return
                            }
                            self.counter -= 1
                            if self.counter > 0 {
                                self.codeButton.setTitle(String( self.counter), for: .normal)
                                self.codeButton.isEnabled = false
                            }else {
                                self.codeButton.setTitle("获取验证码", for: .normal)
                                self.codeButton.isEnabled = true
                            }
                        }
                    }
                    HUD.flash(.label(resp?.msg), delay: 1.0)
                } catch {
                   print(MoyaError.jsonMapping(response))
                }
            case let .failure(error):
                print(error.errorDescription ?? "网络错误")
            }
        }
    }
    @IBAction func loginTap(_ sender: Any) {
        guard let mobile = mobileTextField.text, mobile.count >= 11 else {
            HUD.flash(.label("请输入正确的手机号码"), delay: 1.0)
            return
        }
        serviceProvider.request(.login(mobile: mobile, code: "789456")) { (result) in
            switch result {
            case let .success(response):
                do {
                    print(try response.mapString())
                    let resp = EBResponse<LoginResult>(JSONString: try response.mapString())
                    if let _resp = resp, _resp.code == 0, let _result = _resp.result {
                        UserDefaults.standard.set(_result.uid, forKey: "uid")
                        UserDefaults.standard.set(_result.token, forKey: "token")
                        
                        UIApplication.shared.keyWindow?.rootViewController = EBMainViewController()
//                       let infoVC = EBInfoViewController()
//                        let navi = UINavigationController(rootViewController: infoVC)
//                        self.present(navi, animated: true, completion: nil)
                    }else {
                        HUD.flash(.label(resp?.msg), delay: 1.0)
                    }
                } catch {
                    print(MoyaError.jsonMapping(response))
                }
            case let .failure(error):
                print(error.errorDescription ?? "网络错误")
            }
        }
    }
}
