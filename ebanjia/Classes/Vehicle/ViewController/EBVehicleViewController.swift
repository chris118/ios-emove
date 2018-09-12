//
//  EBVehicleViewController.swift
//  ebanjia
//
//  Created by Chris on 2018/8/9.
//  Copyright © 2018年 ebanjia. All rights reserved.
//

import UIKit
import Moya
import PKHUD

class EBVehicleViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortButton: UIButton!

    private let sortTypes = ["订单最多","评分最高","离我最近"]
    private let sortTypeVlaues = ["order","evaluate","none"]
    private var sortTypeIndex = 0
    
    private var respData: EBResponse<VehicleResult>?
    private var select_id = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupUI()
    }
    
    deinit {
        print("EBVehicleViewController deinit")
    }
    
    private func setupUI() {
        let item = UIBarButtonItem(title: "下一步", style: UIBarButtonItemStyle.plain, target: self, action: #selector(nextTap))
        self.navigationItem.rightBarButtonItem = item
        
        self.tableView.registerNibWithCell(EBVehicleTableViewCell.self)
        self.tableView.tableFooterView = UIView()
    }
    
    private func loadData() {
        EBServiceManager.shared.request(target: EBServiceApi.vehicle(order: sortTypeVlaues[sortTypeIndex])) {[weak self] result in
            guard let `self` = self else {return}
            switch result {
            case let .success(response):
                do {
                    self.respData = EBResponse<VehicleResult>(JSONString: try response.mapString())
                    if let _respData =  self.respData, _respData.code == 0, let _ = _respData.result {
                        self.select_id = _respData.result?.selectedFleetId ?? 0
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
    
    @objc private func nextTap() {
        EBServiceManager.shared.request(target: EBServiceApi.vehicleUpdate(fleet_id: select_id)) {[weak self] result in
            switch result {
            case let .success(response):
                do {
                    let resp = EBResponseEmpty(JSONString: try response.mapString())
                    if let _resp = resp, _resp.code == 0 {
                        let orderVC = EBOrderViewController()
                        self?.navigationController?.pushViewController(orderVC, animated: true)
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
    
    @IBAction func typeTap(_ sender: Any) {
        typePickerView.show()
    }
    
    private lazy var typePickerView: EBItemPickerView = {
        var _typePickerView = EBItemPickerView()
        _typePickerView.items = sortTypes
        _typePickerView.didSelect = {[weak self] index in
            self?.sortTypeIndex = index
            self?.sortButton.titleLabel?.text = self?.sortTypeVlaues[self?.sortTypeIndex ?? 0]
            self?.loadData()
        }
        return _typePickerView
    }()
}

// MARK: UITableView DataSource
extension EBVehicleViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return respData?.result?.usableFleet?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(EBVehicleTableViewCell.self)
        if let usableFleet =  respData?.result?.usableFleet {
            if usableFleet[indexPath.row].fleetId == select_id {
                cell.checked = true
            }else {
                cell.checked = false
            }
            cell.data = usableFleet[indexPath.row]

        }
        return cell
    }
}

// MARK: UITableView Delegate
extension EBVehicleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let usableFleet =  respData?.result?.usableFleet {
            select_id = usableFleet[indexPath.row].fleetId ?? 0
        }
        let contentOffset = tableView.contentOffset
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.setContentOffset(contentOffset, animated: false)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
}
