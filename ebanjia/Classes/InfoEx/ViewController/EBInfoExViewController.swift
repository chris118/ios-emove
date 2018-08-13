//
//  EBInfoExViewController.swift
//  ebanjia
//
//  Created by Chris on 2018/8/9.
//  Copyright © 2018年 ebanjia. All rights reserved.
//

import UIKit

class EBInfoExViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var respData: EBResponse<InfoExResult>?
    private var date = Date()
    private var duration_index = 0
    private var timeSlot_list_string = [String]()
    private var timeSlot_list = [Int: String]()
    private var invoice_index = 0
    private var contact = ""
    private var mobile = ""
    private var mark = ""
    private var is_invoice = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    deinit {
        print("EBInfoExViewController deinit")
    }
    
    private func setupUI() {
        let item = UIBarButtonItem(title: "下一步", style: UIBarButtonItemStyle.plain, target: self, action: #selector(nextTap))
        self.navigationItem.rightBarButtonItem = item
        
        self.tableView.registerNibWithCell(EBInputTableViewCell.self)
        self.tableView.registerNibWithCell(EBSelectTableViewCell.self)
        self.tableView.registerNibWithCell(EBMarkTableViewCell.self)
        self.tableView.tableFooterView = UIView()
    }
    
    private func loadData() {
        respData = EBResponse(JSONString: json)
        if let _timeSlot = respData?.result?.timeSlot {
            for slot in _timeSlot {
                timeSlot_list_string.append(slot.title ?? "")
                timeSlot_list[slot.timeSlotId ?? -1] = slot.title ?? ""
            }
        }
        if let _cartTime = respData?.result?.cartTime {
            let select_slot_id = _cartTime.timeSlotId ?? 0
             duration_index = select_slot_id - 1
            
            var dateComponent = DateComponents.init()
            let calendar = Calendar.current
            dateComponent.year = Int(_cartTime.year ?? "")
            dateComponent.month = Int(_cartTime.month ?? "")
            dateComponent.day = Int(_cartTime.day ?? "")
            date = calendar.date(from: dateComponent) ?? Date()
        }
        
         if let _cartContacts = respData?.result?.cartContacts {
            contact = _cartContacts.userName ?? ""
            mobile = _cartContacts.userTelephone ?? ""
            mark = _cartContacts.userNote ?? ""
            let is_voice = _cartContacts.isInvoice ?? 0
            invoice_index = (is_voice == 1 ? 0 : 1)
        }

        tableView.reloadData()
    }
    
    @objc private func nextTap() {
        let vehicleVC = EBVehicleViewController()
        self.navigationController?.pushViewController(vehicleVC, animated: true)
    }
    
    private lazy var datePickerView: EBDatePickerView = {
        var _pickerView = EBDatePickerView()
        _pickerView.didSelect = {[weak self] date in
            self?.date = date
            self?.tableView.reloadData()
        }
        return _pickerView
    }()
    
    private lazy var durationPickerView: EBItemPickerView = {
        var _durationPickerView = EBItemPickerView()
        _durationPickerView.items = timeSlot_list_string
        _durationPickerView.didSelect = {[weak self] index in
            self?.duration_index = index
            self?.tableView.reloadData()
        }
        return _durationPickerView
    }()
    
    private lazy var invoicePickerView: EBItemPickerView = {
        var _invoicePickerView = EBItemPickerView()
        _invoicePickerView.items = ["是", "否"]
        _invoicePickerView.didSelect = {[weak self] index in
            self?.invoice_index = index
            self?.tableView.reloadData()
        }
        return _invoicePickerView
    }()
}

// MARK: UITableView DataSource
extension EBInfoExViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 {
            return 2
        }else if section == 2 {
            return 1
        }else if section == 3 {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueCell(EBSelectTableViewCell.self)
                cell.titleLabel.text = "选择日期"
                cell.valueLabel.text = date.yyMMdd_String()
                return cell
            case 1:
                let cell = tableView.dequeueCell(EBSelectTableViewCell.self)
                cell.titleLabel.text = "选择时段"
                if timeSlot_list_string.count > 0 {
                    cell.valueLabel.text = timeSlot_list_string[duration_index]
                }
                return cell
            default:
                break
            }
        }else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueCell(EBInputTableViewCell.self)
                cell.titleLabel.text = "负责人"
                cell.valueTextField.placeholder = "请输入负责人姓名"
                cell.valueTextField.text = contact
                return cell
            case 1:
                let cell = tableView.dequeueCell(EBInputTableViewCell.self)
                cell.titleLabel.text = "手机号码"
                cell.valueTextField.placeholder = "请输入负责人手机号码"
                cell.valueTextField.text = mobile
                return cell
            default:
                break
            }
        }else if indexPath.section == 2 {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueCell(EBMarkTableViewCell.self)
                cell.markLabel.text = mark
                return cell
            default:
                break
            }
        }else if indexPath.section == 3 {
            let cell = tableView.dequeueCell(EBSelectTableViewCell.self)
            cell.titleLabel.text = "是否需要发票"
            cell.valueLabel.text = invoice_index == 0 ? "是" : "否"
            return cell
        }
        
        return UITableViewCell()
    }
}

// MARK: UITableView Delegate
extension EBInfoExViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                self.datePickerView.show()
            case 1:
                self.durationPickerView.show()
            default:
                break
            }
        }else if indexPath.section == 3 {
            self.invoicePickerView.show()
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 3 {
            return 20
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 100
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = EBHeaderView()
        if section == 0 {
            headerView.titleLabel.text = "请在下方填写您希望的搬家时间"
        }else if section == 1 {
            headerView.titleLabel.text = "请在下方填写负责人的联系方式"
        }else if section == 2 {
            headerView.titleLabel.text = "备注(非必填)"
        }
        return headerView
    }
}

extension EBInfoExViewController {
    var json: String  {
        get {
            return "{\"code\":0,\"msg\":\"已保存\",\"result\":{\"time_slot\":[{\"time_slot_id\":1,\"title\":\"上午7:00—7:30\"},{\"time_slot_id\":2,\"title\":\"中午10:00—12:00\"},{\"time_slot_id\":3,\"title\":\"下午1:00—2:00\"}],\"cart_time\":{\"year\":\"2018\",\"month\":\"10\",\"day\":\"4\",\"time_slot_id\":1},\"cart_contacts\":{\"user_name\":\"dd\",\"user_telephone\":\"11\",\"user_note\":\"dd\",\"is_invoice\":0}}}"
        }
    }
}
