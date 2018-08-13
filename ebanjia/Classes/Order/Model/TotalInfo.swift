//
//	TotalInfo.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class TotalInfo : NSObject, NSCoding, Mappable{

	var subtitle : String?
	var title : String?
	var type : String?
	var unit : String?
	var value : Float?


	class func newInstance(map: Map) -> Mappable?{
		return TotalInfo()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		subtitle <- map["subtitle"]
		title <- map["title"]
		type <- map["type"]
		unit <- map["unit"]
		value <- map["value"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         subtitle = aDecoder.decodeObject(forKey: "subtitle") as? String
         title = aDecoder.decodeObject(forKey: "title") as? String
         type = aDecoder.decodeObject(forKey: "type") as? String
         unit = aDecoder.decodeObject(forKey: "unit") as? String
         value = aDecoder.decodeObject(forKey: "value") as? Float

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if subtitle != nil{
			aCoder.encode(subtitle, forKey: "subtitle")
		}
		if title != nil{
			aCoder.encode(title, forKey: "title")
		}
		if type != nil{
			aCoder.encode(type, forKey: "type")
		}
		if unit != nil{
			aCoder.encode(unit, forKey: "unit")
		}
		if value != nil{
			aCoder.encode(value, forKey: "value")
		}

	}

}