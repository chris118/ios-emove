//
//	AllGood.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class AllGood : NSObject, NSCoding, Mappable{

	var goodsCubage : Float?
	var goodsId : Int?
	var goodsName : String?
	var parentCategoryId : Int?


	class func newInstance(map: Map) -> Mappable?{
		return AllGood()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		goodsCubage <- map["goods_cubage"]
		goodsId <- map["goods_id"]
		goodsName <- map["goods_name"]
		parentCategoryId <- map["parent_category_id"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         goodsCubage = aDecoder.decodeObject(forKey: "goods_cubage") as? Float
         goodsId = aDecoder.decodeObject(forKey: "goods_id") as? Int
         goodsName = aDecoder.decodeObject(forKey: "goods_name") as? String
         parentCategoryId = aDecoder.decodeObject(forKey: "parent_category_id") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if goodsCubage != nil{
			aCoder.encode(goodsCubage, forKey: "goods_cubage")
		}
		if goodsId != nil{
			aCoder.encode(goodsId, forKey: "goods_id")
		}
		if goodsName != nil{
			aCoder.encode(goodsName, forKey: "goods_name")
		}
		if parentCategoryId != nil{
			aCoder.encode(parentCategoryId, forKey: "parent_category_id")
		}

	}

}