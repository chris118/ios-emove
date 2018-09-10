//
//	Result.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class LoginResult : NSObject, NSCoding, Mappable{

	var avatar : String?
	var groupId : Int?
	var nickname : String?
	var token : String?
	var uid : Int?


	class func newInstance(map: Map) -> Mappable?{
		return LoginResult()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		avatar <- map["avatar"]
		groupId <- map["group_id"]
		nickname <- map["nickname"]
		token <- map["token"]
		uid <- map["uid"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         avatar = aDecoder.decodeObject(forKey: "avatar") as? String
         groupId = aDecoder.decodeObject(forKey: "group_id") as? Int
         nickname = aDecoder.decodeObject(forKey: "nickname") as? String
         token = aDecoder.decodeObject(forKey: "token") as? String
         uid = aDecoder.decodeObject(forKey: "uid") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if avatar != nil{
			aCoder.encode(avatar, forKey: "avatar")
		}
		if groupId != nil{
			aCoder.encode(groupId, forKey: "group_id")
		}
		if nickname != nil{
			aCoder.encode(nickname, forKey: "nickname")
		}
		if token != nil{
			aCoder.encode(token, forKey: "token")
		}
		if uid != nil{
			aCoder.encode(uid, forKey: "uid")
		}

	}

}
