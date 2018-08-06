//
//  EBInputTableViewCell.swift
//  ebanjia
//
//  Created by Chris on 2018/8/2.
//  Copyright © 2018年 ebanjia. All rights reserved.
//

import UIKit

class EBInputTableViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    
    public var valueChanged: ((_ value: String) -> ())?
    public var valueTapped: (() -> ())?
    public var isEnable: Bool = true {
        didSet{
            valueTextField.isEnabled = isEnable
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        valueTextField.delegate = self;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func valueTapped(_ sender: Any) {
        if let _valueTapped = valueTapped {
            _valueTapped()
        }
    }
    
    @IBAction func inputEditingChanged(_ sender: Any) {
        if let _valueChanged = valueChanged {
            _valueChanged(valueTextField.text ?? "")
        }
    }
}
