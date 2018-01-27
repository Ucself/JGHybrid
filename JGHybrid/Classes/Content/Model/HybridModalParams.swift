//
//  HybridModalParams.swift
//  JGHybrid
//
//  Created by 李保君 on 2017/12/11.
//

import UIKit

class HybridModalParams: BaseParams {
    var type:String = "h5"
    var url:String = ""
    var title:String = ""
    var animate:Bool = true
    var fullscreen:Bool = false
    //解析数据对象
    override class func convert(_ dic: [String: AnyObject]) -> HybridModalParams {
        let obj:HybridModalParams = HybridModalParams.init()
        obj.type = dic["type"] as? String ?? "h5"
        obj.url = dic["url"] as? String ?? ""
        obj.title = dic["title"] as? String ?? ""
        obj.animate = dic["animate"] as? Bool ?? true
        obj.fullscreen = dic["fullscreen"] as? Bool ?? true
        return obj
    }
}
