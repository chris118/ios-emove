//
//  EBVehicleViewController.swift
//  ebanjia
//
//  Created by Chris on 2018/8/9.
//  Copyright © 2018年 ebanjia. All rights reserved.
//

import UIKit

class EBVehicleViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var arrowView: UILabel!
    
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
        respData = EBResponse(JSONString: json)
        select_id = respData?.result?.selectedFleetId ?? 0
        tableView.reloadData()
    }
    
    @objc private func nextTap() {
        let orderVC = EBOrderViewController()
        self.navigationController?.pushViewController(orderVC, animated: true)
    }
    
    @IBAction func typeTap(_ sender: Any) {
        typePickerView.show()
    }
    
    private lazy var typePickerView: EBItemPickerView = {
        var _typePickerView = EBItemPickerView()
        _typePickerView.items = ["订单最多","评分最高","离我最近"]
        _typePickerView.didSelect = {[weak self] index in

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

extension EBVehicleViewController {
    var json: String  {
        get {
            return "{\"code\":0,\"msg\":\"\",\"result\":{\"usable_fleet\":[{\"fleet_id\":1006,\"fleet_name\":\"\\u4e0a\\u6d77\\u8682\\u8681\\u642c\\u573a\\u516c\\u53f8\",\"fleet_telephone\":\"021-66621116\",\"fleet_address\":\"\\u4e0a\\u6d77\\u5e02\\u5609\\u5b9a\\u533a\\u5fb7\\u529b\\u897f\\u8def68\\u53f7\",\"distance_kilometer\":22.9,\"evaluate_star\":0,\"evaluate_count\":0,\"order_count\":0,\"remainder\":2,\"discount\":0},{\"fleet_id\":1007,\"fleet_name\":\"\\u4e0a\\u6d77\\u9526\\u901a\\u642c\\u573a\\u516c\\u53f8\",\"fleet_telephone\":\"021-55335533\",\"fleet_address\":\"\\u4e0a\\u6d77\\u5e02\\u5b9d\\u5c71\\u533a\\u547c\\u5170\\u8def455\\u53f7\",\"distance_kilometer\":14.5,\"evaluate_star\":0,\"evaluate_count\":0,\"order_count\":0,\"remainder\":2,\"discount\":0},{\"fleet_id\":1008,\"fleet_name\":\"\\u4e0a\\u6d77\\u516c\\u5174\\u642c\\u573a\\u5357\\u7fd4\\u8f66\\u961f\",\"fleet_telephone\":\"021-66620378\",\"fleet_address\":\"\\u4e0a\\u6d77\\u5e02\\u5609\\u5b9a\\u533a\\u5fb7\\u529b\\u897f\\u8def68\\u53f7\",\"distance_kilometer\":22.9,\"evaluate_star\":0,\"evaluate_count\":0,\"order_count\":0,\"remainder\":2,\"discount\":70},{\"fleet_id\":1009,\"fleet_name\":\"\\u4e0a\\u6d77\\u5409\\u5b89\\u642c\\u573a\\u516c\\u53f8\",\"fleet_telephone\":\"021-56508838\",\"fleet_address\":\"\\u4e0a\\u6d77\\u5e02\\u5b9d\\u5c71\\u533a\\u5bcc\\u8054\\u4e00\\u8def19\\u53f7\",\"distance_kilometer\":20,\"evaluate_star\":0,\"evaluate_count\":0,\"order_count\":0,\"remainder\":1,\"discount\":70},{\"fleet_id\":1011,\"fleet_name\":\"\\u4e0a\\u6d77\\u6c38\\u5174\\u642c\\u573a\\u516c\\u53f8\",\"fleet_telephone\":\"021-56916600\",\"fleet_address\":\"\\u4e0a\\u6d77\\u5e02\\u9759\\u5b89\\u533a\\u664b\\u57ce\\u8def279\\u53f7\",\"distance_kilometer\":10.4,\"evaluate_star\":0,\"evaluate_count\":0,\"order_count\":0,\"remainder\":1,\"discount\":70}],\"move_date\":\"2018-10-4\",\"selected_fleet_id\":1011}}"
        }
    }
}
