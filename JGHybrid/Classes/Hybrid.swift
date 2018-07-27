//
//  MLHybridConfiguration.swift
//  JGHybrid
//
//  Created by 李保君 on 2017/12/5.
//

import Foundation
import WebKit
import JGWebKitURLProtocol
import SSZipArchive

//更换类名 兼容老版本
public typealias MLHybrid = Hybrid

open class Hybrid: NSObject {
    //单例对象
    open static let shared = MLHybrid()
    private override init() {}
    //私有变量
    var delegate: MLHybridMethodProtocol?
    var mainfestParams:HybridMainfestParams = HybridMainfestParams()
    //初始化注册
    open class func register(_ delegate: MLHybridMethodProtocol) {
        shared.delegate = delegate
        //设置拦截
        if HybridConfiguration.default.isRegisterURLProtocol {
            URLProtocol.registerClass(MLHybridURLProtocol.self)
            URLProtocol.wk_registerScheme("http")
            URLProtocol.wk_registerScheme("https")
        }
        //默认开启拦截
        UserDefaults.standard.set(true, forKey: HybridConstantModel.userDefaultSwitchCache)
        //解压压缩包
        if HybridConfiguration.default.isCacheHtml {
            HybridCacheManager.default.HybridUnzipHybiryOfflineZip()
        }
    }
    //加载页面
    open class func load(urlString: String) -> MLHybridViewController? {
        guard let url = URL(string: urlString.hybridUrlPathAllowedString()) else {return nil}
        let webViewController = MLHybridViewController()
        webViewController.urlPath = url
        return webViewController        
    }
    
    //版本检测并更新
    open class func checkMainfest() {
        MLHybirdCommandExecute().hybridOfflineCacheMainfest()
    }
    
    //新的zip包版本检测
    open class func checkOfflinePackage() {
        MLHybirdCommandExecute().hybridOfflinePackage()
    }
}


