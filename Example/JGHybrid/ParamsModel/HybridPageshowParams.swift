//
//  HybridPageshowParams.swift
//  JGHybrid
//
//  Created by 李保君 on 2017/12/11.
//

import UIKit
import JGHybrid

class HybridPageshowParams: HybridBaseParams {
    //解析数据对象
    override class func convert(_ dic: [String: AnyObject]) -> HybridPageshowParams {
        let obj:HybridPageshowParams = HybridPageshowParams.init()
        return obj
    }
}
