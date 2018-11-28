//
//  HybridBackParams.swift
//  JGHybrid
//
//  Created by 李保君 on 2017/12/11.
//

import UIKit

class HybridBackParams: BaseParams {
    var step:Int = 1
    //解析数据对象
    override class func convert(_ dic: [String: AnyObject]) -> HybridBackParams {
        let obj:HybridBackParams = HybridBackParams.init()
        obj.step = dic["step"] as? Int ?? 1
        return obj
    }
}
