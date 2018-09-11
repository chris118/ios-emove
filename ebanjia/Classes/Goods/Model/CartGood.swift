//
//	CartGood.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class CartGood : NSObject, NSCoding, Mappable{

	var goodsCubage : Int?
	var goodsId : Int?
	var goodsName : String?
	var goodsNum : Int?
	var parentCategoryId : Int?


	class func newInstance(map: Map) -> Mappable?{
		return CartGood()
	}
	required init?(map: Map){}
    override init(){
        goodsCubage = 0
        goodsId = 0
        goodsName = ""
        goodsNum = 0
        parentCategoryId = 0
    }

	func mapping(map: Map)
	{
		goodsCubage <- map["goods_cubage"]
		goodsId <- map["goods_id"]
		goodsName <- map["goods_name"]
		goodsNum <- map["goods_num"]
		parentCategoryId <- map["parent_category_id"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         goodsCubage = aDecoder.decodeObject(forKey: "goods_cubage") as? Int
         goodsId = aDecoder.decodeObject(forKey: "goods_id") as? Int
         goodsName = aDecoder.decodeObject(forKey: "goods_name") as? String
         goodsNum = aDecoder.decodeObject(forKey: "goods_num") as? Int
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
		if goodsNum != nil{
			aCoder.encode(goodsNum, forKey: "goods_num")
		}
		if parentCategoryId != nil{
			aCoder.encode(parentCategoryId, forKey: "parent_category_id")
		}

	}

}
