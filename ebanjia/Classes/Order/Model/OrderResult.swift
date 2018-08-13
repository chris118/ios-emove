//
//	Result.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class OrderResult : NSObject, NSCoding, Mappable{

	var banjiaTypeTitle : String?
	var baseInfo : [BaseInfo]?
	var distanceKilometer : Float?
	var fleetAddress : String?
	var fleetName : String?
	var fleetTelephone : String?
	var goodsInfo : [BaseInfo]?
	var isInvoice : Int?
	var moveinAddress : String?
	var moveinDistanceMeter : Int?
	var moveinFloor : Int?
	var moveinIsElevator : Int?
	var moveinIsHandling : Int?
	var moveoutAddress : String?
	var moveoutDistanceMeter : Int?
	var moveoutFloor : Int?
	var moveoutIsElevator : Int?
	var moveoutIsHandling : Int?
	var movingTime : String?
	var totalInfo : [TotalInfo]?
	var userName : String?
	var userNote : String?
	var userTelephone : String?


	class func newInstance(map: Map) -> Mappable?{
		return OrderResult()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		banjiaTypeTitle <- map["banjia_type_title"]
		baseInfo <- map["base_info"]
		distanceKilometer <- map["distance_kilometer"]
		fleetAddress <- map["fleet_address"]
		fleetName <- map["fleet_name"]
		fleetTelephone <- map["fleet_telephone"]
		goodsInfo <- map["goods_info"]
		isInvoice <- map["is_invoice"]
		moveinAddress <- map["movein_address"]
		moveinDistanceMeter <- map["movein_distance_meter"]
		moveinFloor <- map["movein_floor"]
		moveinIsElevator <- map["movein_is_elevator"]
		moveinIsHandling <- map["movein_is_handling"]
		moveoutAddress <- map["moveout_address"]
		moveoutDistanceMeter <- map["moveout_distance_meter"]
		moveoutFloor <- map["moveout_floor"]
		moveoutIsElevator <- map["moveout_is_elevator"]
		moveoutIsHandling <- map["moveout_is_handling"]
		movingTime <- map["moving_time"]
		totalInfo <- map["total_info"]
		userName <- map["user_name"]
		userNote <- map["user_note"]
		userTelephone <- map["user_telephone"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         banjiaTypeTitle = aDecoder.decodeObject(forKey: "banjia_type_title") as? String
         baseInfo = aDecoder.decodeObject(forKey: "base_info") as? [BaseInfo]
         distanceKilometer = aDecoder.decodeObject(forKey: "distance_kilometer") as? Float
         fleetAddress = aDecoder.decodeObject(forKey: "fleet_address") as? String
         fleetName = aDecoder.decodeObject(forKey: "fleet_name") as? String
         fleetTelephone = aDecoder.decodeObject(forKey: "fleet_telephone") as? String
         goodsInfo = aDecoder.decodeObject(forKey: "goods_info") as? [BaseInfo]
         isInvoice = aDecoder.decodeObject(forKey: "is_invoice") as? Int
         moveinAddress = aDecoder.decodeObject(forKey: "movein_address") as? String
         moveinDistanceMeter = aDecoder.decodeObject(forKey: "movein_distance_meter") as? Int
         moveinFloor = aDecoder.decodeObject(forKey: "movein_floor") as? Int
         moveinIsElevator = aDecoder.decodeObject(forKey: "movein_is_elevator") as? Int
         moveinIsHandling = aDecoder.decodeObject(forKey: "movein_is_handling") as? Int
         moveoutAddress = aDecoder.decodeObject(forKey: "moveout_address") as? String
         moveoutDistanceMeter = aDecoder.decodeObject(forKey: "moveout_distance_meter") as? Int
         moveoutFloor = aDecoder.decodeObject(forKey: "moveout_floor") as? Int
         moveoutIsElevator = aDecoder.decodeObject(forKey: "moveout_is_elevator") as? Int
         moveoutIsHandling = aDecoder.decodeObject(forKey: "moveout_is_handling") as? Int
         movingTime = aDecoder.decodeObject(forKey: "moving_time") as? String
         totalInfo = aDecoder.decodeObject(forKey: "total_info") as? [TotalInfo]
         userName = aDecoder.decodeObject(forKey: "user_name") as? String
         userNote = aDecoder.decodeObject(forKey: "user_note") as? String
         userTelephone = aDecoder.decodeObject(forKey: "user_telephone") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if banjiaTypeTitle != nil{
			aCoder.encode(banjiaTypeTitle, forKey: "banjia_type_title")
		}
		if baseInfo != nil{
			aCoder.encode(baseInfo, forKey: "base_info")
		}
		if distanceKilometer != nil{
			aCoder.encode(distanceKilometer, forKey: "distance_kilometer")
		}
		if fleetAddress != nil{
			aCoder.encode(fleetAddress, forKey: "fleet_address")
		}
		if fleetName != nil{
			aCoder.encode(fleetName, forKey: "fleet_name")
		}
		if fleetTelephone != nil{
			aCoder.encode(fleetTelephone, forKey: "fleet_telephone")
		}
		if goodsInfo != nil{
			aCoder.encode(goodsInfo, forKey: "goods_info")
		}
		if isInvoice != nil{
			aCoder.encode(isInvoice, forKey: "is_invoice")
		}
		if moveinAddress != nil{
			aCoder.encode(moveinAddress, forKey: "movein_address")
		}
		if moveinDistanceMeter != nil{
			aCoder.encode(moveinDistanceMeter, forKey: "movein_distance_meter")
		}
		if moveinFloor != nil{
			aCoder.encode(moveinFloor, forKey: "movein_floor")
		}
		if moveinIsElevator != nil{
			aCoder.encode(moveinIsElevator, forKey: "movein_is_elevator")
		}
		if moveinIsHandling != nil{
			aCoder.encode(moveinIsHandling, forKey: "movein_is_handling")
		}
		if moveoutAddress != nil{
			aCoder.encode(moveoutAddress, forKey: "moveout_address")
		}
		if moveoutDistanceMeter != nil{
			aCoder.encode(moveoutDistanceMeter, forKey: "moveout_distance_meter")
		}
		if moveoutFloor != nil{
			aCoder.encode(moveoutFloor, forKey: "moveout_floor")
		}
		if moveoutIsElevator != nil{
			aCoder.encode(moveoutIsElevator, forKey: "moveout_is_elevator")
		}
		if moveoutIsHandling != nil{
			aCoder.encode(moveoutIsHandling, forKey: "moveout_is_handling")
		}
		if movingTime != nil{
			aCoder.encode(movingTime, forKey: "moving_time")
		}
		if totalInfo != nil{
			aCoder.encode(totalInfo, forKey: "total_info")
		}
		if userName != nil{
			aCoder.encode(userName, forKey: "user_name")
		}
		if userNote != nil{
			aCoder.encode(userNote, forKey: "user_note")
		}
		if userTelephone != nil{
			aCoder.encode(userTelephone, forKey: "user_telephone")
		}

	}

}
