//
//  HybridLocationParams.swift
//  JGHybrid
//
//  Created by 李保君 on 2017/12/11.
//

import UIKit
import JGHybrid

class HybridLocationParams: HybridBaseParams {
    var located:String = ""
    var failed:String = ""
    var updated:String = ""
    var precision:String = "normal"
    var timeout:Int32 = 5000
    //解析数据对象
    override class func convert(_ dic: [String: AnyObject]) -> HybridLocationParams {
        let obj:HybridLocationParams = HybridLocationParams.init()
        obj.located = dic["located"] as? String ?? ""
        obj.failed = dic["failed"] as? String ?? ""
        obj.updated = dic["updated"] as? String ?? ""
        obj.precision = dic["precision"] as? String ?? "normal"
        obj.timeout = dic["timeout"] as? Int32 ?? 5000
        return obj
    }
}
