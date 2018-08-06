//
//  EBHeaderView.swift
//  ebanjia
//
//  Created by Chris on 2018/8/2.
//  Copyright © 2018年 ebanjia. All rights reserved.
//

import UIKit
import SnapKit

class EBHeaderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupUI() {
        self.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(self)
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(red: 136/255.0, green: 136/255.0, blue: 136/255.0, alpha: 1)
        return label
    }()
    
}
