//
//  HybridMainfestParams.swift
//  JGHybrid
//
//  Created by 李保君 on 2017/12/11.
//

import UIKit
import JGHybrid

class HybridMainfestParams:HybridBaseParams {
    var _hash:String = ""
    var base:String = ""
    var assets:[String] = []
    var assetsPathExtension:[String] = []
    //解析数据对象
    override class func convert(_ dic: [String: AnyObject]) -> HybridMainfestParams {
        let obj:HybridMainfestParams = HybridMainfestParams.init()
        obj._hash = dic["hash"] as? String ?? ""
        obj.base = dic["base"] as? String ?? ""
        obj.assets = dic["assets"] as? [String] ?? []
        for item in obj.assets {
            let itemSeparatedArray:[String] = item.components(separatedBy: "/")
            if let itemPathExtension = itemSeparatedArray.last {
                obj.assetsPathExtension.append(itemPathExtension)
            }
        }
        return obj
    }
}

