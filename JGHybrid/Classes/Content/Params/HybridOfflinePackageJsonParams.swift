//
//  HybridOfflinePackageJsonParams.swift
//  JGHybrid
//
//  Created by 李保君 on 2018/6/19.
//

import UIKit

class HybridOfflinePackageJsonParams: HybridBaseParams {

    var version:String = ""
    var appName:String = ""
    var source:[HybridOfflinePackageSourceParams] = []
    //解析数据对象
    override class func convert(_ dic: [String: AnyObject]) -> HybridOfflinePackageJsonParams {
        let obj:HybridOfflinePackageJsonParams = HybridOfflinePackageJsonParams.init()
        obj.version = dic["version"] as? String ?? ""
        obj.appName = dic["appName"] as? String ?? ""
        
        if let dataArray = dic["source"] as? [[String: AnyObject]] {
            for itemDic in dataArray {
                let itemSource = HybridOfflinePackageSourceParams.convert(itemDic)
                obj.source.append(itemSource)
            }
        }
        
        return obj
    }
}
//频道资源模型
class HybridOfflinePackageSourceParams: HybridBaseParams {
    
    var id:String = ""              //频道 id
    var key:String = ""             //标识
    var name:String = ""            //频道
    var version:String = ""         //频道 版本
    var bundle:String = ""          //频道 资源
    //解析数据对象
    override class func convert(_ dic: [String: AnyObject]) -> HybridOfflinePackageSourceParams {
        let obj:HybridOfflinePackageSourceParams = HybridOfflinePackageSourceParams.init()
        obj.id = dic["id"] as? String ?? ""
        obj.key = dic["key"] as? String ?? ""
        obj.name = dic["name"] as? String ?? ""
        obj.version = dic["version"] as? String ?? ""
        obj.bundle = dic["bundle"] as? String ?? ""
        return obj
    }
}

//MARK : - 丢弃的模型
class HybridOfflinePackageDataParams: HybridBaseParams {
    
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

class HybridOfflinePackageResourcesParams: HybridBaseParams {
    
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




