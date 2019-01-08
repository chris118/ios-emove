//
//  EBCompanyViewController.swift
//  ebanjia
//
//  Created by admin on 2018/10/2.
//  Copyright © 2018年 ebanjia. All rights reserved.
//

import UIKit
import Moya
import PKHUD

class EBCompanyViewController: UIViewController {
    @IBOutlet weak var companyName: UITextField!
    @IBOutlet weak var contactName: UITextField!
    @IBOutlet weak var contactMobile: UITextField!
    @IBOutlet weak var telephone: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapGesTelephoneAction(_:)))
        tapGes.delegate = self as? UIGestureRecognizerDelegate
        telephone.addGestureRecognizer(tapGes)
        
    }
    @IBAction func submitTap(_ sender: Any) {
        EBServiceManager.shared.request(target: EBServiceApi.companySave(companyName: companyName.text ?? "",
                                                                         contactName: contactName.text ?? "",
                                                                         contactMobile: contactMobile.text ?? "",
                                                                         userNote: "")) {[weak self] result in
            guard let `self` = self else {return}
            switch result {
            case let .success(response):
                do {
                    let resp = EBResponseEmpty(JSONString: try response.mapString())
                    if let _resp = resp, _resp.code == 0 {
                        let actionVC = UIAlertController(title: "", message: "预约成功! 稍后将有我司专员与您联系.", preferredStyle: .alert)
                        let action = UIAlertAction(title: "确定", style: .default, handler: nil)
                        actionVC.addAction(action)
                        self.present(actionVC, animated: true, completion: nil)
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
    
    
    @objc func tapGesTelephoneAction(_ tapGes : UITapGestureRecognizer){
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: "tel:" + (telephone.text ?? ""))!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(URL(string: "tel:" + (telephone.text ?? ""))!)
        }
    }
}
