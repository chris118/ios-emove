//
//  EBServiceManager.swift
//  ebanjia
//
//  Created by Chris on 2018/9/10.
//  Copyright © 2018年 ebanjia. All rights reserved.
//

import Foundation
import Moya

final class EBServiceManager {
    static let shared = EBServiceManager()
    static let responsePlugin = EBResponsePlugin { (result, type) in
        if let complete = _complete {
            complete(result)
        }
    }
    
    static private var _complete: Completion?
    
    private let serviceProvider = MoyaProvider<EBServiceApi>()

    func request(target: TargetType, completion :@escaping Completion) -> Void{
        if let _ = target as? EBServiceApi {
            EBServiceManager._complete = completion
            serviceProvider.request(target as! EBServiceApi) { (result) in
                switch result {
                case let .success(response):
                    do {
                        Swift.print("✈ -------------------------------------------- ✈")
                        Swift.print(try response.mapString())
                        Swift.print("✈ -------------------------------------------- ✈")
                    } catch {
                        print(MoyaError.jsonMapping(response))
                    }
                case let .failure(error):
                    Swift.print("✈ -------------------------------------------- ✈")
                    print(error.errorDescription ?? "网络错误")
                    Swift.print("✈ -------------------------------------------- ✈")
                   
                }
                completion(result)
            }
        }else {
            let error = NSError(domain: "not EBServiceApi tyoe", code: -1, userInfo: nil)
            completion(.failure(MoyaError.underlying(error, nil)))
        }
    }
}
