//
//  EBNoteTableViewCell.swift
//  ebanjia
//
//  Created by Chris on 2018/8/10.
//  Copyright © 2018年 ebanjia. All rights reserved.
//

import UIKit

class EBNoteTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
