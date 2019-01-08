//
//  EBServiceApi.swift
//  ebanjia
//
//  Created by Chris on 2018/8/2.
//  Copyright © 2018年 ebanjia. All rights reserved.
//

import Foundation
import Moya

enum EBServiceApi {
    case requestVerifyCode(mobile: String)
    case login(mobile: String, code: String)
    case info
    case infoUpdate(params: [String: Any])
    case goods
    case goodsCartUpdate(cartGoods : [CartGood])
    case infoex
    case infoexUpdate(params: [String: Any])
    case vehicle(order: String)
    case vehicleUpdate(fleet_id: Int)
    case order
    case orderById(order_id: Int)
    case orderSubmit
    case orderList(page: Int, order_status: String)
    case companySave(companyName: String, contactName: String, contactMobile: String, userNote: String)
}

extension EBServiceApi : TargetType {
    //服务器地址
    var baseURL: URL {
        return URL(string: "https://api.ebanjia.cn")!
    }
    
    //各个请求的具体路径
    var path: String {
        switch self {
        case .requestVerifyCode(_):
            return "/send/login-code"
        case .login(_, _):
            return "/code/login"
        case .info:
            return "/cart/address"
        case .infoUpdate(_):
            return "/cart/address"
        case .goods:
            return "/cart/goods"
        case .goodsCartUpdate(_):
            return "/cart/goods"
        case .infoex:
            return "cart/time"
        case .infoexUpdate(_):
            return "cart/time"
        case .vehicle(_):
            return "cart/fleet"
        case .vehicleUpdate(_):
            return "cart/fleet"
        case .order:
            return "cart/finish"
        case .orderById(_):
            return "get/order"
        case .orderSubmit:
            return "order/save"
        case .orderList(_, _):
            return "get/orders"
        case .companySave(_, _, _, _):
            return "order/company-save"
        }
    }
    
    //请求类型
    var method:  Moya.Method {
        switch self {
        case .requestVerifyCode(_):
            return .get
        case .login(_, _):
            return .post
        case .info:
            return .get
        case .infoUpdate(_):
            return .post
        case .goods:
            return .get
        case .goodsCartUpdate(_):
            return .post
        case .infoex:
            return .get
        case .infoexUpdate(_):
            return .post
        case .vehicle(_):
            return .get
        case .vehicleUpdate(_):
            return .post
        case .order:
            return .get
        case .orderById(_):
            return .get
        case .orderSubmit:
            return .post
        case .orderList(_, _):
            return .get
        case .companySave(_, _, _, _):
            return .post
        }
    }
    
    //请求任务事件（这里附带上参数）
    var task: Task {
        var params = [String: Any]()
        switch self {
        case .login(let mobile, let code):
            params["username"] = mobile
            params["code"] = code
        case .requestVerifyCode(let mobile):
             params["username"] = mobile
         case .info:
            break
        case .infoUpdate(let _params):
            params = _params
        case .goods:
            break
        case .goodsCartUpdate(let cartGoods):
            params["goods"] = cartGoods.toJSONString()
        case .infoex:
            break
        case .infoexUpdate(let _params):
            params = _params
        case .vehicle(let order):
            params["order_by_field"] = order
        case .vehicleUpdate(let fleet_id):
            params["fleet_id"] = fleet_id
        case .order:
            break
        case .orderById(let order_id):
             params["order_id"] = order_id
        case .orderSubmit:
            break
        case .orderList(let page, let order_status):
            params["page"] = page
            params["order_status"] = order_status
            break
        case .companySave(let company_name, let user_name, let user_telephone, let user_note):
            params["company_name"] = company_name
            params["user_name"] = user_name
            params["user_telephone"] = user_telephone
            params["user_note"] = user_note
            break
        }
        
        params["banjia_type"] = EBConfig.banjia_type
        params["eappid"] = 8101

        let uid = UserDefaults.standard.string(forKey: "uid")
        if let _uid = uid {
            params["uid"] = _uid
        }
        let token = UserDefaults.standard.string(forKey: "token")
        if let _token = token {
            params["token"] = _token
        }
        
        Swift.print("✈ -------------------------------------------- ✈")
        Swift.print("\(self.baseURL)\(self.path)")
        params.forEach { Swift.print("\($0.key)\t: \($0.value)") }
        Swift.print("✈ -------------------------------------------- ✈")
        
         return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
    
    //请求头
    var headers: [String : String]? {
        return nil
    }
    
    var sampleData: Data {
        return Data()
    }
}

