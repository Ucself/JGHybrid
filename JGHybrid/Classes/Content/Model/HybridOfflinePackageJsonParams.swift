//
//  HybridOfflinePackageJsonParams.swift
//  JGHybrid
//
//  Created by 李保君 on 2018/6/19.
//

import UIKit

class HybridOfflinePackageJsonParams: BaseParams {

    var errcode:Int = -1
    var data:[HybridOfflinePackageDataParams] = []
    var errmsg:String = ""
    //解析数据对象
    override class func convert(_ dic: [String: AnyObject]) -> HybridOfflinePackageJsonParams {
        let obj:HybridOfflinePackageJsonParams = HybridOfflinePackageJsonParams.init()
        obj.errcode = dic["errcode"] as? Int ?? -1
        if let dataArray = dic["data"] as? [[String: AnyObject]] {
            for itemDic in dataArray {
                let itemData:HybridOfflinePackageDataParams = HybridOfflinePackageDataParams.convert(itemDic)
                obj.data.append(itemData)
            }
        }
        obj.errmsg = dic["errmsg"] as? String ?? ""
        return obj
    }
}

class HybridOfflinePackageDataParams: BaseParams {
    
    var version:String = ""
    var src:String = ""
    //解析数据对象
    override class func convert(_ dic: [String: AnyObject]) -> HybridOfflinePackageDataParams {
        let obj:HybridOfflinePackageDataParams = HybridOfflinePackageDataParams.init()
        obj.version = dic["version"] as? String ?? ""
        obj.src = dic["src"] as? String ?? ""
        return obj
    }
}
