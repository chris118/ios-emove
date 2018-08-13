//
//  EB3ColumnTableViewCell.swift
//  ebanjia
//
//  Created by Chris on 2018/8/10.
//  Copyright © 2018年 ebanjia. All rights reserved.
//

import UIKit

class EB3ColumnTableViewCell: UITableViewCell {
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    var subtitle: String = "" {
        didSet {
            subTitleLabel.text = subtitle
        }
    }
    var value: String = "" {
        didSet {
            valueLabel.text = value
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
