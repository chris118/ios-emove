//
//  CategoryViewController.swift
//  ebanjia
//
//  Created by admin on 2018/10/2.
//  Copyright © 2018年 ebanjia. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
    var tabs = [
        ViewPagerTab(title: "普通搬家",image:nil),
        ViewPagerTab(title: "精致搬家",image:nil),
        ViewPagerTab(title: "企业搬家",image:nil),
    ]
    
    var viewPager:ViewPagerController!
    var options:ViewPagerOptions!
    
    var normalBanjiaVC: EBInfoViewController!
    var advancedBanjiaVC: EBInfoViewController!
    var companyBanjiaVC: EBCompanyViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        initViewPager()
        
        let item = UIBarButtonItem(title: "下一步", style: UIBarButtonItemStyle.plain, target: self, action: #selector(nextTap(sender:)))
        item.tag = 0
        self.navigationItem.rightBarButtonItem = item
    }
    
    private func initViewPager() {
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)

        options = ViewPagerOptions(viewPagerWithFrame: self.view.bounds)
        options.tabType = ViewPagerTabType.basic
        options.tabViewImageSize = CGSize(width: 20, height: 20)
        options.tabViewTextFont = UIFont.systemFont(ofSize: 16)
        options.tabViewPaddingLeft = 20
        options.tabViewPaddingRight = 20
        options.isTabHighlightAvailable = true
        options.isEachTabEvenlyDistributed = true
        options.fitAllTabsInView = true
        
        viewPager = ViewPagerController()
        viewPager.options = options
        viewPager.dataSource = self
        viewPager.delegate = self
        
        self.addChildViewController(viewPager)
        self.view.addSubview(viewPager.view)
        viewPager.didMove(toParentViewController: self)
    }
    
    @objc private func nextTap(sender: UIBarButtonItem) {
        print("\(sender.tag)")
        switch sender.tag {
        case 0:
            normalBanjiaVC.nextTap()
        case 1:
            advancedBanjiaVC.nextTap()
        default:
            break
        }
    }
}

extension CategoryViewController: ViewPagerControllerDataSource {
    
    func numberOfPages() -> Int {
        return tabs.count
    }
    
    func viewControllerAtPosition(position:Int) -> UIViewController {
        switch position {
        case 0:
            normalBanjiaVC = EBInfoViewController()
            normalBanjiaVC.loadData()
            return normalBanjiaVC
        case 1:
            advancedBanjiaVC = EBInfoViewController()
            return advancedBanjiaVC
        default:
            companyBanjiaVC = EBCompanyViewController()
            return companyBanjiaVC
        }
    }
    
    func tabsForPages() -> [ViewPagerTab] {
        return tabs
    }
    
    func startViewPagerAtIndex() -> Int {
        return 0
    }
}

extension CategoryViewController: ViewPagerControllerDelegate {
    
    func willMoveToControllerAtIndex(index:Int) {
        print("Moving to page \(index)")
        EBConfig.banjia_type = index + 1
        switch index {
        case 0:
            normalBanjiaVC.loadData()
        case 1:
            advancedBanjiaVC.loadData()
        default:
            break
        }
    }
    
    func didMoveToControllerAtIndex(index: Int) {
        print("Moved to page \(index)")
        switch index {
        case 0, 1:
            let item = UIBarButtonItem(title: "下一步", style: UIBarButtonItemStyle.plain, target: self, action: #selector(nextTap(sender:)))
            item.tag = index
            self.navigationItem.rightBarButtonItem = item
        case 2:
            self.navigationItem.rightBarButtonItem = nil
        default:
            break
        }
    }
}
