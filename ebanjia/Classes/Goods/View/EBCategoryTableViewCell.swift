//
//  EBCategoryTableViewCell.swift
//  ebanjia
//
//  Created by Chris on 2018/8/8.
//  Copyright © 2018年 ebanjia. All rights reserved.
//

import UIKit

class EBCategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
