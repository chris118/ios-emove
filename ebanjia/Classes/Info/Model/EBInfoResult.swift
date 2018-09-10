//
//	Result.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class EBInfoResult : NSObject, NSCoding, Mappable{

	var movein : EBMovein?
	var moveout : EBMovein?


	class func newInstance(map: Map) -> Mappable?{
		return EBInfoResult()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		movein <- map["movein"]
		moveout <- map["moveout"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         movein = aDecoder.decodeObject(forKey: "movein") as? EBMovein
         moveout = aDecoder.decodeObject(forKey: "moveout") as? EBMovein

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if movein != nil{
			aCoder.encode(movein, forKey: "movein")
		}
		if moveout != nil{
			aCoder.encode(moveout, forKey: "moveout")
		}

	}

}
