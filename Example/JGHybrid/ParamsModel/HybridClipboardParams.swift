//
//  HybridClipboardParams.swift
//  JGHybrid
//
//  Created by 李保君 on 2017/12/11.
//

import UIKit
import JGHybrid

class HybridClipboardParams: HybridBaseParams {
    var content:String = ""
    //解析数据对象
    override class func convert(_ dic: [String: AnyObject]) -> HybridClipboardParams {
        let obj:HybridClipboardParams = HybridClipboardParams.init()
        obj.content = dic["content"] as? String ?? ""
        return obj
    }
}
