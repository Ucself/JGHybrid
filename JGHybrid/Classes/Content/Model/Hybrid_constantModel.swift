//
//  Hybrid_constantModel.swift
//  JGHybrid
//
//  Created by 李保君 on 2017/11/9.
//

import UIKit

class Hybrid_constantModel: NSObject {
    
    static let hybridEvent = "Hybrid.callback"
    static let naviImageHeader = "hybrid_navi_"
    static let switchCache = "HybridSwitchCacheClose"
    static let hybridVersion = "HybridVersion"
    static let updateCookie = "MLHybridUpdateCookie"
    
    //MARK: 资源路径相关
    static let checkVersionQAURL = "http://h5.qa.medlinker.com/app/version/latestList?app=medlinker&sys_p=i&cli_v="
    static let checkVersionURL = "http://h5.medlinker.com/app/version/latestList?app=medlinker&sys_p=i&cli_v="
    static let webAppBaseUrl = "web.qa.medlinker.com"
    
    //URLProtocol相关
    static let urlProtocolHandled = "MLHybridURLProtocolHandled"
    static let types = ["html","js","css","jpg","png"]
    static let contentTpye = ["html": "text/html", "js": "application/javascript", "css": "text/css", "jpg": "image/jpeg", "png": "image/png"]
    
}
