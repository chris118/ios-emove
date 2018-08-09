//
//	CartTime.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class CartTime : NSObject, NSCoding, Mappable{

	var day : String?
	var month : String?
	var timeSlotId : Int?
	var year : String?


	class func newInstance(map: Map) -> Mappable?{
		return CartTime()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		day <- map["day"]
		month <- map["month"]
		timeSlotId <- map["time_slot_id"]
		year <- map["year"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         day = aDecoder.decodeObject(forKey: "day") as? String
         month = aDecoder.decodeObject(forKey: "month") as? String
         timeSlotId = aDecoder.decodeObject(forKey: "time_slot_id") as? Int
         year = aDecoder.decodeObject(forKey: "year") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if day != nil{
			aCoder.encode(day, forKey: "day")
		}
		if month != nil{
			aCoder.encode(month, forKey: "month")
		}
		if timeSlotId != nil{
			aCoder.encode(timeSlotId, forKey: "time_slot_id")
		}
		if year != nil{
			aCoder.encode(year, forKey: "year")
		}

	}

}