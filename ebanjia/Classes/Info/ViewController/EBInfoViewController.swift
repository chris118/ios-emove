//
//  EBInfoViewController.swift
//  ebanjia
//
//  Created by Chris on 2018/8/2.
//  Copyright © 2018年 ebanjia. All rights reserved.
//

import UIKit
import Moya
import PKHUD

class EBInfoViewController: UIViewController {
    private let serviceProvider = MoyaProvider<EBServiceApi>()

    private let elevatorOptions = ["有", "无"]
    private let assembleOptions = ["需要", "不需要"]
    private let floorsOptions = ["1楼","2楼","3楼","4楼","5楼","6楼","7楼","8楼"]
    
    private var out_map_uid = ""
    private var out_adress = ""
    private var elevator_out_index = 0
    private var floor_out_index = 0
    private var assemble_out_index = 0
    private var out_distance = 0
    
    private var in_map_uid = ""
    private var in_adress = ""
    private var elevator_in_index = 0
    private var floor_in_index = 0
    private var assemble_in_index = 0
    private var in_distance = 0
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let item = UIBarButtonItem(title: "下一步", style: UIBarButtonItemStyle.plain, target: self, action: #selector(nextTap))
        self.navigationItem.rightBarButtonItem = item
        
        self.tableView.registerNibWithCell(EBInputTableViewCell.self)
        self.tableView.registerNibWithCell(EBSelectTableViewCell.self)
        self.tableView.tableFooterView = UIView()
        
        loadData()
    }

    deinit {
        print("EBInfoViewController deinit")
    }
    
    @objc private func nextTap() {
        var moveout_params = [String: Any]()
        moveout_params["address"] = out_adress
        moveout_params["floor"] = floor_out_index + 1
        moveout_params["is_elevator"] = elevator_out_index == 0 ? 1 : 0
        moveout_params["is_handling"] = assemble_out_index == 0 ? 1 : 0
        moveout_params["distance_meter"] = out_distance
        moveout_params["uid"] = out_map_uid
        
        var movein_params = [String: Any]()
        movein_params["address"] = in_adress
        movein_params["floor"] = floor_in_index + 1
        movein_params["is_elevator"] = elevator_in_index == 0 ? 1 : 0
        movein_params["is_handling"] = assemble_in_index == 0 ? 1 : 0
        movein_params["distance_meter"] = in_distance
        movein_params["uid"] = in_map_uid
        
        var params = [String: Any]()
        params["moveout"] = moveout_params
        params["movein"] = movein_params
        
        EBServiceManager.shared.request(target: EBServiceApi.infoUpdate(params: params)) {[weak self] result in
            switch result {
            case let .success(response):
                do {
                    let resp = EBResponseEmpty(JSONString: try response.mapString())
                    if let _resp = resp, _resp.code == 0 {
                        let goodsVC = EBGoodsViewController()
                        goodsVC.hidesBottomBarWhenPushed = true
                        self?.navigationController?.pushViewController(goodsVC, animated: true)
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
    
    private func loadData() {
        EBServiceManager.shared.request(target: EBServiceApi.info) {[weak self] result in
            guard let `self` = self else {return}
            switch result {
            case let .success(response):
                do {
                    let resp = EBResponse<EBInfoResult>(JSONString: try response.mapString())
                    if let _resp = resp, _resp.code == 0, let _result = _resp.result {
                        //moveout
                        self.out_adress = _result.moveout?.address ?? ""
                        self.elevator_out_index = (_result.moveout?.isElevator ?? 0) == 1 ? 0 : 1
                        self.floor_out_index = (_result.moveout?.floor ?? 0) - 1
                        self.assemble_out_index = (_result.moveout?.isHandling ?? 0) == 1 ? 0 : 1
                        self.out_distance = _result.moveout?.distanceMeter ?? 0
                        self.out_map_uid = _result.moveout?.uid ?? ""
                        
                        //movein
                        self.in_adress = _result.movein?.address ?? ""
                        self.elevator_in_index = (_result.movein?.isElevator ?? 0) == 1 ? 0 : 1
                        self.floor_in_index = (_result.movein?.floor ?? 0) - 1
                        self.assemble_in_index = (_result.movein?.isHandling ?? 0) == 1 ? 0 : 1
                        self.in_distance = _result.movein?.distanceMeter ?? 0
                        self.in_map_uid = _result.movein?.uid ?? ""
                        
                        self.tableView.reloadData()
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
    
    private lazy var elevatorOutPickerView: EBItemPickerView = {
        var _pickerView = EBItemPickerView()
         _pickerView.items = elevatorOptions
        _pickerView.didSelect = {[weak self]  index in
            self?.elevator_out_index = index
            self?.tableView.reloadData()
        }
        return _pickerView
    }()
    
    private lazy var floorsOutPickerView: EBItemPickerView = {
        var _pickerView = EBItemPickerView()
        _pickerView.items = floorsOptions
        _pickerView.didSelect = {[weak self]  index in
            self?.floor_out_index = index
            self?.tableView.reloadData()
        }
        return _pickerView
    }()
    
    private lazy var assembleOutPickerView: EBItemPickerView = {
        var _pickerView = EBItemPickerView()
        _pickerView.items = assembleOptions
        _pickerView.didSelect = {[weak self] index in
            self?.assemble_out_index = index
            self?.tableView.reloadData()
        }
        return _pickerView
    }()
    
    private lazy var elevatorInPickerView: EBItemPickerView = {
        var _pickerView = EBItemPickerView()
        _pickerView.items = elevatorOptions
        _pickerView.didSelect = {[weak self] index in
            self?.elevator_in_index = index
            self?.tableView.reloadData()
        }
        return _pickerView
    }()
    
    private lazy var floorsInPickerView: EBItemPickerView = {
        var _pickerView = EBItemPickerView()
        _pickerView.items = floorsOptions
        _pickerView.didSelect = {[weak self]  index in
            self?.floor_in_index = index
            self?.tableView.reloadData()
        }
        return _pickerView
    }()
    
    private lazy var assembleInPickerView: EBItemPickerView = {
        var _pickerView = EBItemPickerView()
        _pickerView.items = assembleOptions
        _pickerView.didSelect = {[weak self] index in
            self?.assemble_in_index = index
            self?.tableView.reloadData()
        }
        return _pickerView
    }()
}

// MARK: UITableView DataSource
extension EBInfoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 , self.elevator_out_index == 1 {
            return 5
        }
        if section == 1, self.elevator_in_index == 1 {
            return 5
        }
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueCell(EBInputTableViewCell.self)
                cell.isEnable = false
                cell.valueTextField.text = out_adress
                cell.titleLabel.text = "搬出地址"
                return cell
            case 1:
                let cell = tableView.dequeueCell(EBSelectTableViewCell.self)
                cell.titleLabel.text = "有无电梯"
                cell.valueLabel.text = elevatorOptions[elevator_out_index]
                return cell
            case 2:
                if self.elevator_out_index == 1 {
                    let cell = tableView.dequeueCell(EBSelectTableViewCell.self)
                    cell.titleLabel.text = "选择楼层"
                    cell.valueLabel.text = floorsOptions[floor_out_index]
                    return cell
                }else {
                    let cell = tableView.dequeueCell(EBSelectTableViewCell.self)
                    cell.titleLabel.text = "需要拼装"
                    cell.valueLabel.text = assembleOptions[assemble_out_index]
                    return cell
                }
            case 3:
                if self.elevator_out_index == 1 {
                    let cell = tableView.dequeueCell(EBSelectTableViewCell.self)
                    cell.titleLabel.text = "需要拼装"
                    cell.valueLabel.text = assembleOptions[assemble_out_index]
                    return cell
                }else {
                    let cell = tableView.dequeueCell(EBInputTableViewCell.self)
                    cell.titleLabel.text = "搬出距离"
                    cell.valueTextField.placeholder = "请填写搬出距离"
                    cell.valueTextField.text = "\(self.out_distance)"
                    cell.valueChanged = {[weak self] value in
                        self?.out_distance = Int(value) ?? 0
                    }
                    return cell
                }
            case 4:
                if self.elevator_out_index == 1 {
                    let cell = tableView.dequeueCell(EBInputTableViewCell.self)
                    cell.titleLabel.text = "搬出距离"
                    cell.valueTextField.placeholder = "请填写搬出距离"
                    cell.valueTextField.text = "\(self.out_distance)"
                    cell.valueChanged = {[weak self] value in
                        self?.out_distance = Int(value) ?? 0
                    }
                    return cell
                }
            default:
                break
            }
        }else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueCell(EBInputTableViewCell.self)
                cell.isEnable = false
                cell.valueTextField.text = in_adress
                cell.titleLabel.text = "搬入地址"
                return cell
            case 1:
                let cell = tableView.dequeueCell(EBSelectTableViewCell.self)
                cell.titleLabel.text = "有无电梯"
                cell.valueLabel.text = elevatorOptions[elevator_in_index]
                return cell
            case 2:
                 if self.elevator_in_index == 1 {
                    let cell = tableView.dequeueCell(EBSelectTableViewCell.self)
                    cell.titleLabel.text = "选择楼层"
                    cell.valueLabel.text = floorsOptions[floor_in_index]
                    return cell
                 }else {
                    let cell = tableView.dequeueCell(EBSelectTableViewCell.self)
                    cell.titleLabel.text = "需要拼装"
                    cell.valueLabel.text = assembleOptions[assemble_in_index]
                    return cell
                 }
            case 3:
                 if self.elevator_in_index == 1 {
                    let cell = tableView.dequeueCell(EBSelectTableViewCell.self)
                    cell.titleLabel.text = "需要拼装"
                    cell.valueLabel.text = assembleOptions[assemble_in_index]
                    return cell
                 }else {
                    let cell = tableView.dequeueCell(EBInputTableViewCell.self)
                    cell.titleLabel.text = "搬入距离"
                    cell.valueTextField.placeholder = "请填写搬入距离"
                    cell.valueTextField.text = "\(self.in_distance)"
                    cell.valueChanged = {[weak self] value in
                        self?.in_distance = Int(value) ?? 0
                    }
                    return cell
                 }
            case 4:
                if self.elevator_in_index == 1 {
                    let cell = tableView.dequeueCell(EBInputTableViewCell.self)
                    cell.titleLabel.text = "搬入距离"
                    cell.valueTextField.placeholder = "请填写搬入距离"
                    cell.valueChanged = {[weak self] value in
                        self?.in_distance = Int(value) ?? 0
                    }
                    return cell
                }
            default:
                break
            }
        }
  
        return UITableViewCell()
    }
}

// MARK: UITableView Delegate
extension EBInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let mapVC = EBSearchMapViewController()
                mapVC.itemSelected = { [weak self] (uid, adress: String) in
                    self?.out_map_uid = uid
                    self?.out_adress = adress
                    self?.tableView.reloadData()
                }
                self.present(mapVC, animated: false, completion: nil)
            case 1:
                elevatorOutPickerView.show()
            case 2:
                if self.elevator_out_index == 1 {
                    floorsOutPickerView.show()
                }else {
                    assembleOutPickerView.show()
                }
            case 3:
                if self.elevator_out_index == 1 {
                    assembleOutPickerView.show()
                }
            default:
                break
            }
        }else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                let mapVC = EBSearchMapViewController()
                mapVC.itemSelected = { [weak self] (uid, adress: String) in
                    self?.in_map_uid = uid
                    self?.in_adress = adress
                    self?.tableView.reloadData()
                }
                self.present(mapVC, animated: false, completion: nil)
            case 1:
                elevatorInPickerView.show()
            case 2:
                if self.elevator_in_index == 1 {
                    floorsInPickerView.show()
                }else {
                    assembleInPickerView.show()
                }
            case 3:
                if self.elevator_in_index == 1 {
                    assembleInPickerView.show()
                }
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = EBHeaderView()
        if section == 0 {
            headerView.titleLabel.text = "请在下方填写您的搬出地址"
        }else if section == 1 {
            headerView.titleLabel.text = "请在下方填写您的搬入地址"
        }
        return headerView
    }
}
