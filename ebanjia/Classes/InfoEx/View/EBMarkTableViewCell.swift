//
//  EBMarkTableViewCell.swift
//  ebanjia
//
//  Created by Chris on 2018/8/9.
//  Copyright © 2018年 ebanjia. All rights reserved.
//

import UIKit

class EBMarkTableViewCell: UITableViewCell, UITextViewDelegate {

    public var valueChanged: ((_ value: String) -> ())?
    
    @IBOutlet weak var markLabel: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        markLabel.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
     public func textViewDidChange(_ textView: UITextView){
        if let _valueChanged = valueChanged {
            _valueChanged(markLabel.text ?? "")
        }
    }
}
