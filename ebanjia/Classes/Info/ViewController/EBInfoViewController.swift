//
//  EBInfoViewController.swift
//  ebanjia
//
//  Created by Chris on 2018/8/2.
//  Copyright © 2018年 ebanjia. All rights reserved.
//

import UIKit

class EBInfoViewController: UIViewController {
    private var out_map_uid = ""
    private var out_adress = ""
    
    private var in_map_uid = ""
    private var in_adress = ""
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerNibWithCell(EBInputTableViewCell.self)
        self.tableView.registerNibWithCell(EBSelectTableViewCell.self)
        self.tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let item = UIBarButtonItem(title: "下一步", style: UIBarButtonItemStyle.plain, target: self, action: #selector(nextTap))
        self.tabBarController?.navigationItem.rightBarButtonItem = item
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    @objc private func nextTap() {
        let goodsVC = EBGoodsViewController()
        self.tabBarController?.navigationController?.pushViewController(goodsVC, animated: true)
    }
    
    private lazy var elevatorPickerView: EBItemPickerView = {
        var _pickerView = EBItemPickerView()
         _pickerView.items = ["有", "无"]
        _pickerView.didSelect = { index in
            print(index)
        }
        return _pickerView
    }()
    
    private lazy var assemblePickerView: EBItemPickerView = {
        var _pickerView = EBItemPickerView()
        _pickerView.items = ["需要", "不需要"]
        _pickerView.didSelect = { index in
            print(index)
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
                cell.valueLabel.text = "有"
                return cell
            case 2:
                let cell = tableView.dequeueCell(EBSelectTableViewCell.self)
                cell.titleLabel.text = "需要拼装"
                cell.valueLabel.text = "需要"
                return cell
            case 3:
                let cell = tableView.dequeueCell(EBInputTableViewCell.self)
                cell.titleLabel.text = "搬出距离"
                cell.valueTextField.placeholder = "请填写搬出距离"
                return cell
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
                cell.valueLabel.text = "有"
                return cell
            case 2:
                let cell = tableView.dequeueCell(EBSelectTableViewCell.self)
                cell.titleLabel.text = "需要拼装"
                cell.valueLabel.text = "需要"
                return cell
            case 3:
                let cell = tableView.dequeueCell(EBInputTableViewCell.self)
                cell.titleLabel.text = "搬入距离"
                cell.valueTextField.placeholder = "请填写搬入距离"
                return cell
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
                elevatorPickerView.show()
            case 2:
                assemblePickerView.show()
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
                elevatorPickerView.show()
            case 2:
                assemblePickerView.show()
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
