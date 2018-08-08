//
//	FirstCategory.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class Category : NSObject, NSCoding, Mappable{

	var categoryId : Int?
	var categoryName : String?
	var parentCategoryId : Int?


	class func newInstance(map: Map) -> Mappable?{
		return Category()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		categoryId <- map["category_id"]
		categoryName <- map["category_name"]
		parentCategoryId <- map["parent_category_id"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         categoryId = aDecoder.decodeObject(forKey: "category_id") as? Int
         categoryName = aDecoder.decodeObject(forKey: "category_name") as? String
         parentCategoryId = aDecoder.decodeObject(forKey: "parent_category_id") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if categoryId != nil{
			aCoder.encode(categoryId, forKey: "category_id")
		}
		if categoryName != nil{
			aCoder.encode(categoryName, forKey: "category_name")
		}
		if parentCategoryId != nil{
			aCoder.encode(parentCategoryId, forKey: "parent_category_id")
		}

	}

}
