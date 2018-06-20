//
//  HybridOfflinePackageJsonParams.swift
//  JGHybrid
//
//  Created by 李保君 on 2018/6/19.
//

import UIKit

class HybridOfflinePackageJsonParams: BaseParams {

    var errcode:Int = -1
    var data:HybridOfflinePackageDataParams = HybridOfflinePackageDataParams()
    var errmsg:String = ""
    //解析数据对象
    override class func convert(_ dic: [String: AnyObject]) -> HybridOfflinePackageJsonParams {
        let obj:HybridOfflinePackageJsonParams = HybridOfflinePackageJsonParams.init()
        obj.errcode = dic["errcode"] as? Int ?? -1
        if let dataDic = dic["data"] as? [String: AnyObject] {
            obj.data = HybridOfflinePackageDataParams.convert(dataDic)
        }
        obj.errmsg = dic["errmsg"] as? String ?? ""
        return obj
    }
}

class HybridOfflinePackageDataParams: BaseParams {
    
    var version:String = ""
    var resources:[HybridOfflinePackageResourcesParams] = []
    //解析数据对象
    override class func convert(_ dic: [String: AnyObject]) -> HybridOfflinePackageDataParams {
        let obj:HybridOfflinePackageDataParams = HybridOfflinePackageDataParams.init()
        obj.version = dic["version"] as? String ?? ""
        if let resourcesArray = dic["resources"] as? [[String:AnyObject]] {
            for itemDic in resourcesArray {
                let itemResources:HybridOfflinePackageResourcesParams = HybridOfflinePackageResourcesParams.convert(itemDic)
                obj.resources.append(itemResources)
            }
        }
        return obj
    }
}

class HybridOfflinePackageResourcesParams: BaseParams {
    
    var channel:String = ""
    var version:String = ""
    var src:String = ""
    //解析数据对象
    override class func convert(_ dic: [String: AnyObject]) -> HybridOfflinePackageResourcesParams {
        let obj:HybridOfflinePackageResourcesParams = HybridOfflinePackageResourcesParams.init()
        obj.channel = dic["channel"] as? String ?? ""
        obj.version = dic["version"] as? String ?? ""
        obj.src = dic["src"] as? String ?? ""
        return obj
    }
}




