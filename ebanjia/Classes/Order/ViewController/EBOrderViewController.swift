//
//  EBOrderViewController.swift
//  ebanjia
//
//  Created by Chris on 2018/8/10.
//  Copyright © 2018年 ebanjia. All rights reserved.
//

import UIKit

class EBOrderViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var respData: EBResponse<OrderResult>?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupUI()
    }
    
    deinit {
        print("EBOrderViewController deinit")
    }
    
    private func setupUI() {
        let item = UIBarButtonItem(title: "提交订单", style: UIBarButtonItemStyle.plain, target: self, action: #selector(nextTap))
        self.navigationItem.rightBarButtonItem = item
        
        self.tableView.registerNibWithCell(EB2ColumnTableViewCell.self)
        self.tableView.registerNibWithCell(EB3ColumnTableViewCell.self)
        self.tableView.registerNibWithCell(EBInputTableViewCell.self)
        self.tableView.registerNibWithCell(EBMarkTableViewCell.self)
        self.tableView.registerNibWithCell(EBNoteTableViewCell.self)
        self.tableView.tableFooterView = UIView()
    }
    
    private func loadData() {
        respData = EBResponse(JSONString: json)
    }
    
    @objc private func nextTap() {
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.selectedIndex = 2
        
        self.navigationController?.popToRootViewController(animated: false)

    }
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
                cell.valueTextField.textColor = UIColor(red: 12/255.0, green: 142/255.0, blue: 233/255.0, alpha: 1)
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

extension EBOrderViewController {
    var json: String  {
        get {
            return "{\"code\":0,\"msg\":\"\",\"result\":{\"banjia_type_title\":\"普通搬家\",\"user_name\":\"dd\",\"user_telephone\":\"11\",\"user_note\":\"dd\",\"moving_time\":\"2018-10-04 上午7:00—7:30\",\"moveout_address\":\"上海市 上海市杨浦区通北路589号保利绿地广场L楼\",\"moveout_floor\":1,\"moveout_is_elevator\":0,\"moveout_is_handling\":0,\"moveout_distance_meter\":44,\"movein_address\":\"上海市 凯旋北路1111号GG密室雷欧咖啡\",\"movein_floor\":1,\"movein_is_elevator\":0,\"movein_is_handling\":0,\"movein_distance_meter\":55,\"is_invoice\":0,\"fleet_name\":\"上海锦通搬场公司\",\"fleet_telephone\":\"021-55335533\",\"fleet_address\":\"上海市宝山区呼兰路455号\",\"distance_kilometer\":14.5,\"base_info\":[{\"type\":\"base\",\"title\":\"车辆基础价\",\"subtitle\":\"该费用包含运输车辆费用（）以及人员费用（驾驶员名，搬运工若干名）\",\"value\":800,\"unit\":\"元\"},{\"type\":\"base\",\"title\":\"运输公里收费\",\"subtitle\":\"该费用包含您的运输距离费用，基础运距为10.0公里，超出部分按每公里8元收费\",\"value\":20.8,\"unit\":\"元\"},{\"type\":\"base\",\"title\":\"楼层费用\",\"subtitle\":\"该费用包含您的上下楼层搬运费用，有电梯统一收费60元，无电梯按每层40元收费\",\"value\":0,\"unit\":\"元\"},{\"type\":\"base\",\"title\":\"拼装、分卸费用\",\"subtitle\":\"每增加一个装卸点收费。\",\"value\":0,\"unit\":\"元\"},{\"type\":\"base\",\"title\":\"搬运超距费\",\"subtitle\":\"基础运距为40米，超出部分按每米6元收费\",\"value\":354,\"unit\":\"元\"}],\"goods_info\":[{\"type\":\"goods\",\"title\":\"3门书橱（红木或柚木需拆装）\",\"subtitle\":\"该费用包含搬运、摆放费用\",\"value\":200,\"unit\":\"元\"},{\"type\":\"goods\",\"title\":\"柜子（红木或柚木）\",\"subtitle\":\"该费用包含搬运、摆放费用\",\"value\":50,\"unit\":\"元\"}],\"total_info\":[{\"type\":\"total\",\"title\":\"物品总体积\",\"subtitle\":\"根据您选择的物品计算\",\"value\":3.3,\"unit\":\"m³\"},{\"type\":\"total\",\"title\":\"总行程\",\"subtitle\":\"该距离为搬出地址至搬入地址的距离\",\"value\":12.6,\"unit\":\"公里\"},{\"type\":\"total\",\"title\":\"总费用\",\"subtitle\":\"本单可参加砍价活动，最低可砍至0元\",\"value\":1424.8,\"unit\":\"元\"}]}}"
        }
    }
}
