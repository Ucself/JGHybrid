//
//  Hybrid_constantModel.swift
//  JGHybrid
//
//  Created by 李保君 on 2017/11/9.
//

import UIKit

class Hybrid_constantModel: NSObject {
    
    static var hybridEvent = "Hybrid.callback"
    static var naviImageHeader = "hybrid_navi_"
    static var switchCache = "HybridSwitchCacheClose"
    static var hybridVersion = "HybridVersion"
    static var updateCookie = "MLHybridUpdateCookie"
    
    //MARK: 资源路径相关
    static var checkVersionQAURL = "http://h5.qa.medlinker.com/app/version/latestList?app=medlinker&sys_p=i&cli_v="
    static var checkVersionURL = "http://h5.medlinker.com/app/version/latestList?app=medlinker&sys_p=i&cli_v="
    static var webAppBaseUrl = "web.qa.medlinker.com"
    
    //URLProtocol相关
    static var urlProtocolHandled = "MLHybridURLProtocolHandled"
    static var types = ["html","js","css","jpg","png"]
    static var contentTpye = ["html": "text/html", "js": "application/javascript", "css": "text/css", "jpg": "image/jpeg", "png": "image/png"]
    
}
