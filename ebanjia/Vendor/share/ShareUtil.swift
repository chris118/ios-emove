//
//  ShareUtil.swift
//  ebanjia
//
//  Created by admin on 2018/10/2.
//  Copyright © 2018年 ebanjia. All rights reserved.
//

import Foundation

class ShareUtil {
    class func shareSessiton(orderId: Int) {
        // 1.创建分享参数
        let shareParames = NSMutableDictionary()
        shareParames.ssdkSetupShareParams(byText: "我在【e搬家】平台下单搬家了，请来帮我砍价吧，最低可砍到免费搬家！【e搬家】快乐搬新家!",
                                          images : UIImage(named: "bg_top"),
                                          url : NSURL(string:"https://www.ebanjia.cn/cut/\(orderId)")! as URL,
                                          title : "快来帮我砍价搬家",
                                          type : SSDKContentType.webPage)
        
        //2.进行分享
        ShareSDK.share(SSDKPlatformType.subTypeWechatSession, parameters: shareParames) { (state : SSDKResponseState, nil, entity : SSDKContentEntity?, error :Error?) in
            
            switch state{
                
            case SSDKResponseState.success: print("分享成功")
            case SSDKResponseState.fail:    print("授权失败,错误描述:\(String(describing: error))")
            case SSDKResponseState.cancel:  print("操作取消")
                
            default:
                break
            }
        }
    }
}
