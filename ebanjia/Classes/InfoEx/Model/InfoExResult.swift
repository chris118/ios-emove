//
//	Result.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper

class InfoExResult:NSObject, NSCoding, Mappable{

	var cartContacts : CartContact?
	var cartTime : CartTime?
	var timeSlot : [TimeSlot]?

	required init?(map: Map){
    }

    override init() {}
    func mapping(map: Map)
	{
		cartContacts <- map["cart_contacts"]
		cartTime <- map["cart_time"]
		timeSlot <- map["time_slot"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         cartContacts = aDecoder.decodeObject(forKey: "cart_contacts") as? CartContact
         cartTime = aDecoder.decodeObject(forKey: "cart_time") as? CartTime
         timeSlot = aDecoder.decodeObject(forKey: "time_slot") as? [TimeSlot]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if cartContacts != nil{
			aCoder.encode(cartContacts, forKey: "cart_contacts")
		}
		if cartTime != nil{
			aCoder.encode(cartTime, forKey: "cart_time")
		}
		if timeSlot != nil{
			aCoder.encode(timeSlot, forKey: "time_slot")
		}

	}

}
