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
            params["banjia_type"] = 1
            break
        }
        
        let uid = UserDefaults.standard.string(forKey: "uid")
        if let _uid = uid {
            params["uid"] = _uid
        }
        let token = UserDefaults.standard.string(forKey: "token")
        if let _token = token {
            params["token"] = _token
        }
        
        params["eappid"] = 8101
        
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

