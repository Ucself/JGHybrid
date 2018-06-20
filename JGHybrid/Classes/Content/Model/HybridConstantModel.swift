//
//  Hybrid_constantModel.swift
//  JGHybrid
//
//  Created by 李保君 on 2017/11/9.
//

import UIKit

class HybridConstantModel: NSObject {
    //缓存少量文件Key
    static var userDefaultSwitchCache = "HybridSwitchCache"
    static var userDefaultMainfest = "HybridMainfest"
    static var userDefaultOfflineVersion = "HybridOfflineVersion"
    //URLProtocol相关
    static var urlProtocolHandled = "MLHybridURLProtocolHandled"
    static var types = ["html","js","css","jpg","png","jpeg"]
    static var contentTpye = ["html": "text/html", "js": "application/javascript", "css": "text/css", "jpg": "image/jpeg", "png": "image/png"]
    //常量
    static var offlinePackageFolder  = "HybridOfflinePackage"
    
}
