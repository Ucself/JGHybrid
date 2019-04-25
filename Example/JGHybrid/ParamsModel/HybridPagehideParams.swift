//
//  HybridPagehideParams.swift
//  JGHybrid
//
//  Created by 李保君 on 2017/12/11.
//

import UIKit
import JGHybrid

class HybridPagehideParams: HybridBaseParams {
    //解析数据对象
    override class func convert(_ dic: [String: AnyObject]) -> HybridPagehideParams {
        let obj:HybridPagehideParams = HybridPagehideParams.init()
        return obj
    }
}
