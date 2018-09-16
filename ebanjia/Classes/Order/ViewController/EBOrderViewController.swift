//
//  EBOrderViewController.swift
//  ebanjia
//
//  Created by Chris on 2018/8/10.
//  Copyright © 2018年 ebanjia. All rights reserved.
//

import UIKit
import Moya
import PKHUD

class EBOrderViewController: UIViewController {
    var orderId: Int?
    
    @IBOutlet weak var tableView: UITableView!

    private var respData: EBResponse<OrderResult>?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    deinit {
        print("EBOrderViewController deinit")
    }
    
    private func setupUI() {
        self.tableView.registerNibWithCell(EB2ColumnTableViewCell.self)
        self.tableView.registerNibWithCell(EB3ColumnTableViewCell.self)
        self.tableView.registerNibWithCell(EBInputTableViewCell.self)
        self.tableView.registerNibWithCell(EBMarkTableViewCell.self)
        self.tableView.registerNibWithCell(EBNoteTableViewCell.self)
        self.tableView.tableFooterView = UIView()
        self.tableView.tableHeaderView = headerView
        
        if let _ = orderId {
            loadDataByID()
        }else {
            let item = UIBarButtonItem(title: "提交订单", style: UIBarButtonItemStyle.plain, target: self, action: #selector(nextTap))
            self.navigationItem.rightBarButtonItem = item
            loadData()
        }
    }
    
    private func loadData() {
        EBServiceManager.shared.request(target: EBServiceApi.order) {[weak self] result in
            guard let `self` = self else {return}
            switch result {
            case let .success(response):
                do {
                    self.respData = EBResponse<OrderResult>(JSONString: try response.mapString())
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
    
    private func loadDataByID() {
        EBServiceManager.shared.request(target: EBServiceApi.orderById(order_id: orderId ?? 0)) {[weak self] result in
            guard let `self` = self else {return}
            switch result {
            case let .success(response):
                do {
                    self.respData = EBResponse<OrderResult>(JSONString: try response.mapString())
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
    
    @objc private func nextTap() {
        EBServiceManager.shared.request(target: EBServiceApi.orderSubmit) {[weak self] result in
            guard let `self` = self else {return}
            switch result {
            case let .success(response):
                do {
                    let resp = EBResponseEmpty(JSONString: try response.mapString())
                    if let _resp = resp, _resp.code == 0 {
                        self.tabBarController?.tabBar.isHidden = false
                        self.tabBarController?.selectedIndex = 2
                        self.navigationController?.popToRootViewController(animated: false)
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
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 90)
        view.backgroundColor = UIColor(red: 0, green: 146/255.0, blue: 224/255.0, alpha: 1)

        let label1 = UILabel(frame: CGRect(x: 0, y: 15, width: UIScreen.main.bounds.width, height: 20))
        label1.textAlignment = .center
        label1.textColor = UIColor.white
        label1.font = UIFont.systemFont(ofSize: 12)
        label1.text = "若订单信息有误或有疑问"
        
        let label2 = UILabel(frame: CGRect(x: 0, y: 45, width: UIScreen.main.bounds.width, height: 20))
        label2.textAlignment = .center
        label2.textColor = UIColor.white
        label2.font = UIFont.systemFont(ofSize: 12)
        label2.text = "可致电e搬家客服热线400-400-6668寻求帮助"
        
        view.addSubview(label1)
        view.addSubview(label2)
        return view
    }()
}


// MARK: UITableView DataSource
extension EBOrderViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 6
        case 1:
            return 2
        case 2:
            return respData?.result?.baseInfo?.count ?? 0
        case 3:
            return respData?.result?.goodsInfo?.count ?? 0
        case 4:
            return respData?.result?.totalInfo?.count ?? 0
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let cell = tableView.dequeueCell(EB2ColumnTableViewCell.self)
                cell.title1Label.text = "联系人:"
                cell.title2Label.text = "联系电话:"
                cell.value1Label.text = respData?.result?.userName ?? ""
                cell.value2Label.text = respData?.result?.userTelephone ?? ""
                return cell
            }else if indexPath.row == 1 {
                let cell = tableView.dequeueCell(EBInputTableViewCell.self)
                cell.isEnable = false
                cell.titleLabel.text = "搬家时间:"
                cell.valueTextField.text = respData?.result?.movingTime ?? ""
                cell.valueTextField.textColor = UIColor(red: 0, green: 146/255.0, blue: 224/255.0, alpha: 1)
                return cell
            }else if indexPath.row == 2 {
                let cell = tableView.dequeueCell(EBInputTableViewCell.self)
                cell.isEnable = false
                cell.titleLabel.text = "搬出地址:"
                let address = respData?.result?.moveoutAddress ?? ""
                let elevator = (respData?.result?.moveoutIsElevator ?? 0) == 1 ? "有" : "无"
                let distance = String(respData?.result?.moveoutDistanceMeter ?? 0)
                cell.valueTextField.text = "\(address)(\(elevator)电梯\(distance)米)"
                return cell
            }else if indexPath.row == 3 {
                let cell = tableView.dequeueCell(EBInputTableViewCell.self)
                cell.isEnable = false
                cell.titleLabel.text = "搬入地址:"
                let address = respData?.result?.moveinAddress ?? ""
                let elevator = (respData?.result?.moveinIsElevator ?? 0) == 1 ? "有" : "无"
                let distance = String(respData?.result?.moveinDistanceMeter ?? 0)
                cell.valueTextField.text = "\(address)(\(elevator)电梯\(distance)米)"
                return cell
            }else if indexPath.row == 4 {
                let cell = tableView.dequeueCell(EBInputTableViewCell.self)
                cell.isEnable = false
                cell.titleLabel.text = "发票需求:"
                let isInvoice = (respData?.result?.isInvoice ?? 0) == 0 ? "不需要" : "需要"
                cell.valueTextField.text = "已选择\(isInvoice)发票"
                return cell
            }else if indexPath.row == 5 {
                let cell = tableView.dequeueCell(EBNoteTableViewCell.self)
                cell.titleLabel.text = "客户备注:"
                cell.valueTextView.text = respData?.result?.userNote ?? ""
                return cell
            }
        case 1:
            if indexPath.row == 0 {
                let cell = tableView.dequeueCell(EB2ColumnTableViewCell.self)
                cell.title1Label.text = "车队名称:"
                cell.title2Label.text = "联系电话:"
                cell.value1Label.text = respData?.result?.fleetName ?? ""
                cell.value2Label.text = respData?.result?.fleetTelephone ?? ""
                return cell
            }else if indexPath.row == 1 {
                let cell = tableView.dequeueCell(EBInputTableViewCell.self)
                cell.isEnable = false
                cell.titleLabel.text = "车队地址"
                cell.valueTextField.text = respData?.result?.fleetAddress ?? ""
                return cell
            }
        case 2:
            if let _baseInfo = respData?.result?.baseInfo {
                let cell = tableView.dequeueCell(EB3ColumnTableViewCell.self)
                cell.title = _baseInfo[indexPath.row].title ?? ""
                cell.subtitle = _baseInfo[indexPath.row].subtitle ?? ""
                let value = String(_baseInfo[indexPath.row].value ?? 0)
                let unit = _baseInfo[indexPath.row].unit ?? ""
                cell.value = value + unit
                return cell
            }
        case 3:
            if let _goodsInfo = respData?.result?.goodsInfo {
                let cell = tableView.dequeueCell(EB3ColumnTableViewCell.self)
                cell.title = _goodsInfo[indexPath.row].title ?? ""
                cell.subtitle = _goodsInfo[indexPath.row].subtitle ?? ""
                let value = String(_goodsInfo[indexPath.row].value ?? 0)
                let unit = _goodsInfo[indexPath.row].unit ?? ""
                cell.value = value + unit
                return cell
            }
        case 4:
            if let _totalInfo = respData?.result?.totalInfo {
                let cell = tableView.dequeueCell(EB3ColumnTableViewCell.self)
                cell.title = _totalInfo[indexPath.row].title ?? ""
                cell.subtitle = _totalInfo[indexPath.row].subtitle ?? ""
                let value = String(_totalInfo[indexPath.row].value ?? 0)
                let unit = _totalInfo[indexPath.row].unit ?? ""
                cell.value = value + unit
                return cell
            }
        default:
            break
        }
        return UITableViewCell()
    }
}

// MARK: UITableView Delegate
extension EBOrderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0, indexPath.row == 5 {
            return 80
        }else if indexPath.section == 2 {
            if let _baseInfo = respData?.result?.baseInfo {
               let _subtitle = _baseInfo[indexPath.row].subtitle
               let height = _subtitle?.height(withConstrainedWidth: UIScreen.main.bounds.width, font: UIFont.systemFont(ofSize: 12)) ?? 0
                return height + 50
            }
        }else if indexPath.section == 3 {
            if let _goodsInfo = respData?.result?.goodsInfo {
                let _subtitle = _goodsInfo[indexPath.row].subtitle
                let height = _subtitle?.height(withConstrainedWidth: UIScreen.main.bounds.width, font: UIFont.systemFont(ofSize: 12)) ?? 0
                return height + 50
            }
        }else if indexPath.section == 4 {
            if let _totalInfo = respData?.result?.totalInfo {
                let _subtitle = _totalInfo[indexPath.row].subtitle
                let height = _subtitle?.height(withConstrainedWidth: UIScreen.main.bounds.width, font: UIFont.systemFont(ofSize: 12)) ?? 0
                return height + 50
            }
        }
        return 40
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = EBHeaderView()
        if section == 0 {
            headerView.titleLabel.text = "基础信息"
        }else if section == 1 {
            headerView.titleLabel.text = "服务车队信息"
        }else if section == 2 {
            headerView.titleLabel.text = "基础收费项目"
        }else if section == 3 {
            headerView.titleLabel.text = "贵重物品收费"
        }else if section == 4 {
            headerView.titleLabel.text = "总计"
        }
        return headerView
    }
}
