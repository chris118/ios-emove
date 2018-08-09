//
//  EBDatePickerView.swift
//  ebanjia
//
//  Created by Chris on 2018/8/9.
//  Copyright © 2018年 ebanjia. All rights reserved.
//

import UIKit

class EBDatePickerView: UIView {
    
    var didSelect: ((Date) -> ())?
    
    func show() {
        overlayView.show()
        contentView.frame.origin.y = farHeight
        UIView.animate(withDuration: 0.3) {
            self.contentView.frame.origin.y = UIScreen.main.bounds.height - self.heightContent
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.frame.origin.y = self.farHeight
        }) { (complete) in
            self.overlayView.hide()
        }
    }
    
    private let heightContent: CGFloat = 280
    private let farHeight: CGFloat = 2000
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupUI() {
        contentView.addSubview(dataPickView)
        overlayView.addSubview(contentView)
    }
    
    private lazy var overlayView: EBMaskView = {
        var _mask = EBMaskView()
        return _mask
    }()
    
    private lazy var contentView: UIView = {
        var content = EBContentView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - heightContent, width: UIScreen.main.bounds.width, height: heightContent))
        content.cancel = {[weak self] in
            self?.hide()
        }
        content.confirm = {[weak self] in
            self?.hide()
            if let _didSelect = self?.didSelect {
                _didSelect((self?.dataPickView.date)!)
            }
        }
        return content
    }()
    
    private lazy var dataPickView: UIDatePicker = {
        var _pickerView = UIDatePicker(frame: CGRect(x: 0, y: 45, width: UIScreen.main.bounds.width, height: heightContent - 45))
        _pickerView.datePickerMode = .date
        return _pickerView
    }()
}
