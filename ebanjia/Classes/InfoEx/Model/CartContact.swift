//
//	CartContact.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class CartContact : NSObject, NSCoding, Mappable{

	var isInvoice : Int?
	var userName : String?
	var userNote : String?
	var userTelephone : String?


	class func newInstance(map: Map) -> Mappable?{
		return CartContact()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		isInvoice <- map["is_invoice"]
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
         isInvoice = aDecoder.decodeObject(forKey: "is_invoice") as? Int
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
		if isInvoice != nil{
			aCoder.encode(isInvoice, forKey: "is_invoice")
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