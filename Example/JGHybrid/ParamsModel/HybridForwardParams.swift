//
//  HybridForwardParams.swift
//  JGHybrid
//
//  Created by 李保君 on 2017/12/11.
//

import UIKit
import JGHybrid

class HybridForwardParams: HybridBaseParams {
    
    var type:String = "h5"
    var url:String = ""
    var title:String = ""
    var color:String = ""
    var background:String = ""
    var animate:Bool = true
    var fullscreen:Bool = false
    var fullscreenBackGestures:Bool = false
    var characterAllowed:Bool = false
    //解析数据对象
    override class func convert(_ dic: [String: AnyObject]) -> HybridForwardParams {
        let obj:HybridForwardParams = HybridForwardParams.init()
        obj.type = dic["type"] as? String ?? "h5"
        obj.url = dic["url"] as? String ?? ""
        obj.title = dic["title"] as? String ?? ""
        obj.color = dic["color"] as? String ?? ""
        obj.background = dic["background"] as? String ?? ""
        obj.animate = dic["animate"] as? Bool ?? true
        obj.fullscreen = dic["fullscreen"] as? Bool ?? false
        obj.fullscreenBackGestures = dic["fullscreenBackGestures"] as? Bool ?? false
        obj.characterAllowed = dic["characterAllowed"] as? Bool ?? false
        return obj
    }
}
