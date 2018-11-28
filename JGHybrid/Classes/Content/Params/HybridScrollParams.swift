//
//  HybridScrollParams.swift
//  JGHybrid
//
//  Created by 李保君 on 2017/12/11.
//

import UIKit

class HybridScrollParams: BaseParams {
    var enable:Bool = true
    var background:String = ""
    //解析数据对象
    override class func convert(_ dic: [String: AnyObject]) -> HybridScrollParams {
        let obj:HybridScrollParams = HybridScrollParams.init()
        obj.enable = dic["enable"] as? Bool ?? true
        obj.background = dic["background"] as? String ?? ""
        return obj
    }
}
