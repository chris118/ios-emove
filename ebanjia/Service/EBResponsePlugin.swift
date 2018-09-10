//
//  EBResponsePlugin.swift
//  ebanjia
//
//  Created by Chris on 2018/9/10.
//  Copyright © 2018年 ebanjia. All rights reserved.
//

import Foundation
import Moya
import Result

public final class EBResponsePlugin: PluginType {
    
    public typealias EBResponseClosure = (_ result: Result<Moya.Response, Moya.MoyaError>, _ target: TargetType) -> Void
    let responseClosure: EBResponseClosure
    
    public init(responseClosure: @escaping EBResponseClosure) {
        self.responseClosure = responseClosure
    }
    
    // MARK: Plugin
    
    public func willSend(_ request: RequestType, target: TargetType) {
    }
    
    public func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        responseClosure(result, target)
    }
}
