//
//  Date+extension.swift
//  ebanjia
//
//  Created by Chris on 2018/8/9.
//  Copyright © 2018年 ebanjia. All rights reserved.
//

import Foundation

public extension String {
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin).union(.truncatesLastVisibleLine)
        let boundingBox = self.boundingRect(with: constraintRect, options: options, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return CGFloat(ceilf(Float(boundingBox.height)))
    }
    
    func width(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin).union(.truncatesLastVisibleLine)
        let boundingBox = self.boundingRect(with: constraintRect, options: options, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return CGFloat(ceilf(Float(boundingBox.width)))
    }
}
