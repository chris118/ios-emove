//
//  EBResponse.swift
//  ebanjia
//
//  Created by Chris on 2018/8/2.
//  Copyright © 2018年 ebanjia. All rights reserved.
//

import Foundation
import ObjectMapper

class EBResponseEmpty: Mappable {
    required init?(map: Map) {
    }
    
    var code : Int?
    var msg : String?
    
    func mapping(map: Map)
    {
        code <- map["code"]
        msg <- map["msg"]
    }
}

class EBResponse <T: Mappable>:NSCoding, Mappable{
    
    var code : Int?
    var msg : String?
    var result : T?
    
    required init?(map: Map){}

    func mapping(map: Map)
    {
        code <- map["code"]
        msg <- map["msg"]
        result <- map["result"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        code = aDecoder.decodeObject(forKey: "code") as? Int
        msg = aDecoder.decodeObject(forKey: "msg") as? String
        result = aDecoder.decodeObject(forKey: "result") as? T
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if code != nil{
            aCoder.encode(code, forKey: "code")
        }
        if msg != nil{
            aCoder.encode(msg, forKey: "msg")
        }
        if result != nil{
            aCoder.encode(result, forKey: "result")
        }
        
    }
    
}
