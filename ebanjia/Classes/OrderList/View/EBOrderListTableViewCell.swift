//
//  EBOrderListTableViewCell.swift
//  ebanjia
//
//  Created by Chris on 2018/8/13.
//  Copyright © 2018年 ebanjia. All rights reserved.
//

import UIKit

class EBOrderListTableViewCell: UITableViewCell {
    
    var kanjiaTap: ((Int)->())?
    var orderTap: ((Int)->())?
    public var orderId: Int?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var adressOutLabel: UILabel!
    @IBOutlet weak var adressInLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var orderButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        orderButton.layer.borderWidth = 1
        orderButton.layer.borderColor = UIColor(red: 15/255.5, green: 142/255.0, blue: 233/155.0, alpha: 1).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func kanjiaTap(_ sender: Any) {
        if let _kanjiaTap = kanjiaTap {
            _kanjiaTap(orderId ?? 0)
        }
    }
    @IBAction func orderTap(_ sender: Any) {
        if let _orderTap = orderTap {
            _orderTap(orderId ?? 0)
        }
    }
}
