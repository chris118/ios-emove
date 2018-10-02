//
//  ViewPagerOptions.swift
//  ViewPager-Swift
//
//  Created by Nishan on 2/9/16.
//  Copyright © 2016 Nishan. All rights reserved.
//

import UIKit
import Foundation

public class ViewPagerOptions {
    
    public var viewPagerFrame:CGRect = CGRect.zero
    
    // Tabs Customization
    public var tabType:ViewPagerTabType = .basic
    public var isTabHighlightAvailable:Bool = false
    public var isTabIndicatorAvailable:Bool = true
    public var tabViewBackgroundDefaultColor:UIColor = Color.tabViewBackground
    public var tabViewBackgroundHighlightColor:UIColor = Color.tabViewHighlight
    public var tabViewTextDefaultColor:UIColor = Color.textDefault
    public var tabViewTextHighlightColor:UIColor = Color.textHighlight
    
    // Booleans
    
    /// Width of each tab is equal to the width of the largest tab. Tabs are laid out from Left - Right and are scrollable
    public var isEachTabEvenlyDistributed:Bool = false
    /// All the tabs are squeezed to fit inside the screen width. Tabs are not scrollable. Also it overrides isEachTabEvenlyDistributed
    public var fitAllTabsInView:Bool = false
    
    // Tab Properties
    public var tabViewHeight:CGFloat = 50.0
    public var tabViewPaddingLeft:CGFloat = 10.0
    public var tabViewPaddingRight:CGFloat = 10.0
    public var tabViewTextFont:UIFont = UIFont.systemFont(ofSize: 16)
    public var tabViewImageSize:CGSize = CGSize(width: 25, height: 25)
    public var tabViewImageMarginTop:CGFloat = 5
    public var tabViewImageMarginBottom:CGFloat = 5
    
    // Tab Indicator
    public var tabIndicatorViewHeight:CGFloat = 3
    public var tabIndicatorViewBackgroundColor:UIColor = Color.tabIndicator
    
    // ViewPager
    public var viewPagerTransitionStyle:UIPageViewControllerTransitionStyle = .scroll
    
    /**
     * Initializes Options for ViewPager. The frame of the supplied UIView in view parameter is
     * used as reference for ViewPager width and height.
     */
    public init(viewPagerWithFrame frame:CGRect) {
        self.viewPagerFrame = frame
    }
    
    fileprivate struct Color {
        
        static let tabViewBackground = UIColor.white
        static let tabViewHighlight = UIColor.white
        static let textDefault = UIColor.black
        static let textHighlight = UIColor(red: 0, green: 144/255.0, blue: 227/255.0, alpha: 1)
        static let tabIndicator = UIColor(red: 0, green: 144/255.0, blue: 227/255.0, alpha: 1)
    }
}

fileprivate extension UIColor {
    
    class func from(r: CGFloat,g:CGFloat,b:CGFloat) -> UIColor {
        return UIColor(red: r / 255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
}
