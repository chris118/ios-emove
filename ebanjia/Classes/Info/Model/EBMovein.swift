//
//	Movein.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class EBMovein : NSObject, NSCoding, Mappable{

	var address : String?
	var distanceMeter : Int?
	var floor : Int?
	var isElevator : Int?
	var isHandling : Int?
	var lat : Float?
	var lng : Float?
	var uid : String?


	class func newInstance(map: Map) -> Mappable?{
		return EBMovein()
	}
	required init?(map: Map){}
	override init(){}

	func mapping(map: Map)
	{
		address <- map["address"]
		distanceMeter <- map["distance_meter"]
		floor <- map["floor"]
		isElevator <- map["is_elevator"]
		isHandling <- map["is_handling"]
		lat <- map["lat"]
		lng <- map["lng"]
		uid <- map["uid"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         address = aDecoder.decodeObject(forKey: "address") as? String
         distanceMeter = aDecoder.decodeObject(forKey: "distance_meter") as? Int
         floor = aDecoder.decodeObject(forKey: "floor") as? Int
         isElevator = aDecoder.decodeObject(forKey: "is_elevator") as? Int
         isHandling = aDecoder.decodeObject(forKey: "is_handling") as? Int
         lat = aDecoder.decodeObject(forKey: "lat") as? Float
         lng = aDecoder.decodeObject(forKey: "lng") as? Float
         uid = aDecoder.decodeObject(forKey: "uid") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if address != nil{
			aCoder.encode(address, forKey: "address")
		}
		if distanceMeter != nil{
			aCoder.encode(distanceMeter, forKey: "distance_meter")
		}
		if floor != nil{
			aCoder.encode(floor, forKey: "floor")
		}
		if isElevator != nil{
			aCoder.encode(isElevator, forKey: "is_elevator")
		}
		if isHandling != nil{
			aCoder.encode(isHandling, forKey: "is_handling")
		}
		if lat != nil{
			aCoder.encode(lat, forKey: "lat")
		}
		if lng != nil{
			aCoder.encode(lng, forKey: "lng")
		}
		if uid != nil{
			aCoder.encode(uid, forKey: "uid")
		}

	}

}
