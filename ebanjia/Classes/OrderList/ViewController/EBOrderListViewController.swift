//
//  EBOrderListViewController.swift
//  ebanjia
//
//  Created by admin on 2018/8/5.
//  Copyright © 2018年 ebanjia. All rights reserved.
//

import UIKit
import Moya
import PKHUD

class EBOrderListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortButton: UIButton!

    private var respData: EBResponseList<EBOrderListResult>?
    private let orderTypes = ["全部订单","完成订单","未完成订单"]
    private let orderTypeVlaues = ["none","finish","'wait'"]
    private var orderTypeIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    deinit {
        print("EBOrderListViewController deinit")
    }
    
    private func loadData() {
        EBServiceManager.shared.request(target: EBServiceApi.orderList(page: 1, order_status: orderTypeVlaues[orderTypeIndex])) {[weak self] result in
            guard let `self` = self else {return}
            switch result {
            case let .success(response):
                do {
                    self.respData = EBResponseList<EBOrderListResult>(JSONString: try response.mapString())
                    if let _respData =  self.respData, _respData.code == 0, let _ = _respData.result {
                        self.respData = _respData
                        self.tableView.reloadData()
                    }else {
                        HUD.flash(.label(self.respData?.msg), delay: 1.0)
                    }
                } catch {
                    print(MoyaError.jsonMapping(response))
                }
            case let .failure(error):
                print(error.errorDescription ?? "网络错误")
            }
        }
    }
    
    private func setupUI() {
        self.title = "订单列表"
        self.tableView.registerNibWithCell(EBOrderListTableViewCell.self)
        self.tableView.tableFooterView = UIView()
    }
    
    @IBAction func typeTap(_ sender: Any) {
        typePickerView.show()
    }
    
    private lazy var typePickerView: EBItemPickerView = {
        var _typePickerView = EBItemPickerView()
        _typePickerView.items = orderTypes
        _typePickerView.didSelect = {[weak self] index in
            self?.orderTypeIndex = index
            self?.sortButton.titleLabel?.text = self?.orderTypes[self?.orderTypeIndex ?? 0]
            self?.loadData()
        }
        return _typePickerView
    }()
}


// MARK: UITableView DataSource
extension EBOrderListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return respData?.result?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(EBOrderListTableViewCell.self)
        if let _result = respData?.result?[indexPath.row] {
            cell.orderId = respData?.result?[indexPath.row].orderId
            
            cell.titleLabel.text = _result.orderSn ?? ""
            cell.adressOutLabel.text = _result.moveoutAddress ?? ""
            cell.adressInLabel.text = _result.moveinAddress ?? ""
            cell.timeLabel.text = "\(_result.movingTime ?? "") \(_result.timeSlotTitle ?? "")"
            
            let status = _result.orderStatus ?? ""
            if status == "finish" {
                 cell.statusLabel.text = "完成"
            }else {
                 cell.statusLabel.text = "未完成"
            }
            
            cell.kanjiaTap = {[weak self] orderId in
                let kanjiaVC = EBKanjiaViewController()
                 kanjiaVC.orderId = orderId
                self?.navigationController?.pushViewController(kanjiaVC, animated: true)
            }
            
            cell.orderTap = {[weak self] orderId in
                let orderVC = EBOrderViewController()
                orderVC.orderId = orderId
                self?.navigationController?.pushViewController(orderVC, animated: true)
            }
        }
        return cell
    }
}

// MARK: UITableView Delegate
extension EBOrderListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
}
