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
//        obj._hash = dic["hash"] as? String ?? ""
//        obj.base = dic["base"] as? String ?? ""
//        obj.assets = dic["assets"] as? [String] ?? []
//        for item in obj.assets {
//            let itemSeparatedArray:[String] = item.components(separatedBy: "/")
//            if let itemPathExtension = itemSeparatedArray.last {
//                obj.assetsPathExtension.append(itemPathExtension)
//            }
//        }
        return obj
    }
}

class HybridOfflinePackageDataParams: BaseParams {
    
    var version:String = ""
    var src:String = ""
    //解析数据对象
    override class func convert(_ dic: [String: AnyObject]) -> HybridOfflinePackageDataParams {
        let obj:HybridOfflinePackageDataParams = HybridOfflinePackageDataParams.init()
        //        obj._hash = dic["hash"] as? String ?? ""
        //        obj.base = dic["base"] as? String ?? ""
        //        obj.assets = dic["assets"] as? [String] ?? []
        //        for item in obj.assets {
        //            let itemSeparatedArray:[String] = item.components(separatedBy: "/")
        //            if let itemPathExtension = itemSeparatedArray.last {
        //                obj.assetsPathExtension.append(itemPathExtension)
        //            }
        //        }
        return obj
    }
}
