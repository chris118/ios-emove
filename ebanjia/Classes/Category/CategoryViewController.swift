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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewPager()
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
}

extension CategoryViewController: ViewPagerControllerDataSource {
    
    func numberOfPages() -> Int {
        return tabs.count
    }
    
    func viewControllerAtPosition(position:Int) -> UIViewController {
        switch position {
        case 0:
            let vc = EBInfoViewController()
            return vc
        case 1:
            let vc = EBInfoViewController()
            return vc
        default:
            let vc = EBCompanyViewController()
            return vc
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
    }
    
    func didMoveToControllerAtIndex(index: Int) {
        print("Moved to page \(index)")
    }
}
