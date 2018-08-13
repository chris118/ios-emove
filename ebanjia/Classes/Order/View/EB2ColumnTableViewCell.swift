//
//  EB2ColumnTableViewCell.swift
//  ebanjia
//
//  Created by Chris on 2018/8/10.
//  Copyright © 2018年 ebanjia. All rights reserved.
//

import UIKit

class EB2ColumnTableViewCell: UITableViewCell {
    @IBOutlet weak var title1Label: UILabel!
    @IBOutlet weak var value1Label: UILabel!
    @IBOutlet weak var title2Label: UILabel!
    @IBOutlet weak var value2Label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
