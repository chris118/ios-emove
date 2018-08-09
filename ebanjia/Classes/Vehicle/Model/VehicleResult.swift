//
//	Result.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class VehicleResult : NSObject, NSCoding, Mappable{

	var moveDate : String?
	var selectedFleetId : Int?
	var usableFleet : [UsableFleet]?

	class func newInstance(map: Map) -> Mappable?{
		return VehicleResult()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		moveDate <- map["move_date"]
		selectedFleetId <- map["selected_fleet_id"]
		usableFleet <- map["usable_fleet"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         moveDate = aDecoder.decodeObject(forKey: "move_date") as? String
         selectedFleetId = aDecoder.decodeObject(forKey: "selected_fleet_id") as? Int
         usableFleet = aDecoder.decodeObject(forKey: "usable_fleet") as? [UsableFleet]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if moveDate != nil{
			aCoder.encode(moveDate, forKey: "move_date")
		}
		if selectedFleetId != nil{
			aCoder.encode(selectedFleetId, forKey: "selected_fleet_id")
		}
		if usableFleet != nil{
			aCoder.encode(usableFleet, forKey: "usable_fleet")
		}

	}

}
