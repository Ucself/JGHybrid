//
//  HybridHeaderParams.swift
//  JGHybrid
//
//  Created by 李保君 on 2017/12/11.
//

import UIKit

class HybridHeaderParams: BaseParams {
    var title:String = ""
    var show:Bool = true
    var color:String = ""
    var background:String = ""
    var left:[HybridHeaderButtonParams] = []
    var right:[HybridHeaderButtonParams] = []
    //解析数据对象
    override class func convert(_ dic: [String: AnyObject]) -> HybridHeaderParams {
        let obj:HybridHeaderParams = HybridHeaderParams.init()
        obj.title = dic["title"] as? String ?? ""
        obj.show = dic["show"] as? Bool ?? true
        obj.color = dic["color"] as? String ?? ""
        obj.background = dic["background"] as? String ?? ""
        //左边Button
        if let leftArray:[[String: AnyObject]] = dic["left"] as? [[String: AnyObject]] {
            for leftSingle:[String: AnyObject] in leftArray {
                obj.left.append(HybridHeaderButtonParams.convert(leftSingle))
            }
        }
        //右边Button
        if let rightArray:[[String: AnyObject]] = dic["right"] as? [[String: AnyObject]] {
            for rightSingle:[String: AnyObject] in rightArray {
                obj.right.append(HybridHeaderButtonParams.convert(rightSingle))
            }
        }
        return obj
    }
    
    //Header 下的Button
    class HybridHeaderButtonParams : BaseParams{
        var title:String = ""
        var callback:String = ""
        var icon:String = ""
        var color:String = ""
        //解析数据对象
        override class func convert(_ dic: [String: AnyObject]) -> HybridHeaderButtonParams {
            let obj:HybridHeaderButtonParams = HybridHeaderButtonParams.init()
            obj.title = dic["title"] as? String ?? ""
            obj.callback = dic["callback"] as? String ?? ""
            obj.icon = dic["icon"] as? String ?? ""
            obj.color = dic["color"] as? String ?? ""
            return obj
        }
    }
    
}
