//
//	Result.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class GoodsResult: NSCoding, Mappable{

	var allGoods : [AllGood]?
	var cartGoods : [CartGood]?
	var firstCategory : [Category]?
	var secondCategory : [Category]?

	required init?(map: Map){
    }

    func mapping(map: Map)
	{
		allGoods <- map["all_goods"]
		cartGoods <- map["cart_goods"]
		firstCategory <- map["first_category"]
		secondCategory <- map["second_category"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         allGoods = aDecoder.decodeObject(forKey: "all_goods") as? [AllGood]
         cartGoods = aDecoder.decodeObject(forKey: "cart_goods") as? [CartGood]
         firstCategory = aDecoder.decodeObject(forKey: "first_category") as? [Category]
         secondCategory = aDecoder.decodeObject(forKey: "second_category") as? [Category]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if allGoods != nil{
			aCoder.encode(allGoods, forKey: "all_goods")
		}
		if cartGoods != nil{
			aCoder.encode(cartGoods, forKey: "cart_goods")
		}
		if firstCategory != nil{
			aCoder.encode(firstCategory, forKey: "first_category")
		}
		if secondCategory != nil{
			aCoder.encode(secondCategory, forKey: "second_category")
		}

	}

}
