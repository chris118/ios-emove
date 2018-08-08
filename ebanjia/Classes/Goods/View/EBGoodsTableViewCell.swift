//
//  EBGoodsTableViewCell.swift
//  ebanjia
//
//  Created by Chris on 2018/8/8.
//  Copyright © 2018年 ebanjia. All rights reserved.
//

import UIKit

class EBGoodsTableViewCell: UITableViewCell {
    var number: Int = 0 {
        didSet {
            if number <= 0 {
                minusButton.isHidden = true
                numberLabel.isHidden = true
            }else {
                numberLabel.text = String(number)
                minusButton.isHidden = false
                numberLabel.isHidden = false
            }
        }
    }
    
    var plus: (()->())?
    var minus: (()->())?
    
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.number = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func plusTap(_ sender: Any) {
        self.number = self.number + 1
        if let _plus = plus {
            _plus()
        }
    }
    
    @IBAction func minusTap(_ sender: Any) {
        self.number = self.number - 1
        if let _minus = minus {
            _minus()
        }
    }
}
