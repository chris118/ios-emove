//
//  EBResponse.swift
//  ebanjia
//
//  Created by Chris on 2018/8/2.
//  Copyright © 2018年 ebanjia. All rights reserved.
//

import UIKit
import ObjectMapper

class EBResponse: Mappable {
    var code: Int?
    var msg: String?
    var result: String?
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        code    <- map["code"]
        msg     <- map["msg"]
        result  <- map["result"]
    }
}
