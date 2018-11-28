//
//  HybridStorageParams.swift
//  JGHybrid
//
//  Created by 李保君 on 2018/1/30.
//

import UIKit

class HybridStorageParams: BaseParams {

    var action:String = ""
    var hashDic:[String:String] = [:]
    //解析数据对象
    override class func convert(_ dic: [String: AnyObject]) -> HybridStorageParams {
        let obj:HybridStorageParams = HybridStorageParams.init()
        obj.action = dic["action"] as? String ?? ""
        obj.hashDic = dic["hash"] as? [String:String] ?? [:]
        return obj
    }
}
