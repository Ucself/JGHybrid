//
//  HybridInitParams.swift
//  JGHybrid
//
//  Created by 李保君 on 2017/12/11.
//

import UIKit
import JGHybrid

class HybridInitParams: HybridBaseParams {
    var cache:Bool = true                               //离线缓存，默认开启
    var callback_name:String = "Hybrid.callback"        //回调js方法名称
    //解析数据对象
    override class func convert(_ dic: [String: AnyObject]) -> HybridInitParams {
        let obj:HybridInitParams = HybridInitParams.init()
        obj.cache = dic["cache"] as? Bool ?? true
        obj.callback_name = dic["callback_name"] as? String ?? "Hybrid.callback"
        return obj
    }
}
