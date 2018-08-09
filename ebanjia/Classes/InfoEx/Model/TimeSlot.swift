//
//	TimeSlot.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class TimeSlot : NSObject, NSCoding, Mappable{

	var timeSlotId : Int?
	var title : String?


	class func newInstance(map: Map) -> Mappable?{
		return TimeSlot()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		timeSlotId <- map["time_slot_id"]
		title <- map["title"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         timeSlotId = aDecoder.decodeObject(forKey: "time_slot_id") as? Int
         title = aDecoder.decodeObject(forKey: "title") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if timeSlotId != nil{
			aCoder.encode(timeSlotId, forKey: "time_slot_id")
		}
		if title != nil{
			aCoder.encode(title, forKey: "title")
		}

	}

}