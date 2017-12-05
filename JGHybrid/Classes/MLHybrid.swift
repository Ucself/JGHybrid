//
//  MLHybrid.swift
//  Pods
//

import Foundation
import WebKit
import JGWebKitURLProtocol

public protocol MLHybridMethodProtocol {
    func methodExtension(command: MLHybirdCommand)
}

open class MLHybrid {
    //单例对象
    open static let shared = MLHybrid()
    private init() {}
    //室友变量
    var delegate: MLHybridMethodProtocol?
    var mainfestParams:HybridMainfestParams = HybridMainfestParams()
    //初始化注册
    open class func register(_ delegate: MLHybridMethodProtocol) {
        shared.delegate = delegate
        //设置拦截
        URLProtocol.registerClass(MLHybridURLProtocol.self)
        //默认开启拦截
        UserDefaults.standard.set(true, forKey: Hybrid_constantModel.switchCache)
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
        MLHybridTools().hybridOfflineCacheMainfest()
    }
}
