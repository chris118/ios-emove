//
//  UITableView+Reuse.swift
//  ebanjia
//
//  Created by Chris on 2018/8/2.
//  Copyright © 2018年 ebanjia. All rights reserved.
//

import UIKit

extension UITableView {
    //MARK: - Cell
    public func registerNibWithCell<CellType: UITableViewCell>(_ cell: CellType.Type) {
        let name = String(describing: cell)
        self.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
    }
    
    public func registerClassWithCell<CellType: UITableViewCell>(_ cell: CellType.Type) {
        self.register(cell, forCellReuseIdentifier: String(describing: cell))
    }
    
    public func dequeueCell<CellType: UITableViewCell>(_ cell: CellType.Type) -> CellType {
        return self.dequeueReusableCell(withIdentifier: String(describing: cell)) as! CellType
    }
    
    public func dequeueCell<CellType: UITableViewCell>(_ cell: CellType.Type, for indexPath: IndexPath) -> CellType {
        return self.dequeueReusableCell(withIdentifier: String(describing: cell), for: indexPath) as! CellType
    }
    
    //MARK: - HeaderFooterView
    public func registerNibWithHeaderFooterView<CellType: UITableViewHeaderFooterView>(_ headerFooterView: CellType.Type) {
        let name = String(describing: headerFooterView)
        self.register(UINib(nibName: name, bundle: nil), forHeaderFooterViewReuseIdentifier: name)
    }
    
    public func registerClassWithHeaderFooterView<CellType: UITableViewHeaderFooterView>(_ headerFooterView: CellType.Type) {
        self.register(headerFooterView, forHeaderFooterViewReuseIdentifier: String(describing: headerFooterView))
    }
    
    public func dequeueHeaderFooterView<CellType: UITableViewHeaderFooterView>(_ headerFooterView: CellType.Type) -> CellType {
        return self.dequeueReusableHeaderFooterView(withIdentifier: String(describing: headerFooterView)) as! CellType
    }
    
}
