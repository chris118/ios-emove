//
//	UsableFleet.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class UsableFleet : NSObject, NSCoding, Mappable{

	var discount : Int?
	var distanceKilometer : Float?
	var evaluateCount : Int?
	var evaluateStar : Int?
	var fleetAddress : String?
	var fleetId : Int?
	var fleetName : String?
	var fleetTelephone : String?
	var orderCount : Int?
	var remainder : Int?


	class func newInstance(map: Map) -> Mappable?{
		return UsableFleet()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		discount <- map["discount"]
		distanceKilometer <- map["distance_kilometer"]
		evaluateCount <- map["evaluate_count"]
		evaluateStar <- map["evaluate_star"]
		fleetAddress <- map["fleet_address"]
		fleetId <- map["fleet_id"]
		fleetName <- map["fleet_name"]
		fleetTelephone <- map["fleet_telephone"]
		orderCount <- map["order_count"]
		remainder <- map["remainder"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         discount = aDecoder.decodeObject(forKey: "discount") as? Int
         distanceKilometer = aDecoder.decodeObject(forKey: "distance_kilometer") as? Float
         evaluateCount = aDecoder.decodeObject(forKey: "evaluate_count") as? Int
         evaluateStar = aDecoder.decodeObject(forKey: "evaluate_star") as? Int
         fleetAddress = aDecoder.decodeObject(forKey: "fleet_address") as? String
         fleetId = aDecoder.decodeObject(forKey: "fleet_id") as? Int
         fleetName = aDecoder.decodeObject(forKey: "fleet_name") as? String
         fleetTelephone = aDecoder.decodeObject(forKey: "fleet_telephone") as? String
         orderCount = aDecoder.decodeObject(forKey: "order_count") as? Int
         remainder = aDecoder.decodeObject(forKey: "remainder") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if discount != nil{
			aCoder.encode(discount, forKey: "discount")
		}
		if distanceKilometer != nil{
			aCoder.encode(distanceKilometer, forKey: "distance_kilometer")
		}
		if evaluateCount != nil{
			aCoder.encode(evaluateCount, forKey: "evaluate_count")
		}
		if evaluateStar != nil{
			aCoder.encode(evaluateStar, forKey: "evaluate_star")
		}
		if fleetAddress != nil{
			aCoder.encode(fleetAddress, forKey: "fleet_address")
		}
		if fleetId != nil{
			aCoder.encode(fleetId, forKey: "fleet_id")
		}
		if fleetName != nil{
			aCoder.encode(fleetName, forKey: "fleet_name")
		}
		if fleetTelephone != nil{
			aCoder.encode(fleetTelephone, forKey: "fleet_telephone")
		}
		if orderCount != nil{
			aCoder.encode(orderCount, forKey: "order_count")
		}
		if remainder != nil{
			aCoder.encode(remainder, forKey: "remainder")
		}

	}

}