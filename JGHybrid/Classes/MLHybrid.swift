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
    
    var delegate: MLHybridMethodProtocol?
    //私有变量
    static let unregistered = "unregistered"
    var sess: String = unregistered
    var platform: String = unregistered
    var userAgent: String = unregistered
    var scheme: String = unregistered
    var domain: String = unregistered
    var backIndicator: String = unregistered
    
    //注册信息
    //应用启动、登陆、注销 都需要调用
    open class func register(sess: String,
                             platform: String,
                             appName: String,
                             backIndicator: String,
                             delegate: MLHybridMethodProtocol) {
        shared.sess = sess
        shared.platform = platform
        shared.userAgent = "doc_hybrid_" + appName + "_"
        shared.scheme = "doc" + appName + "hybrid"
        shared.backIndicator = backIndicator
        shared.delegate = delegate
        //设置UserAgent
        //MLHybrid.configUserAgent()
        
        //设置拦截
//        URLProtocol.registerClass(MLHybridURLProtocol.self)
//        URLProtocol.wk_registerScheme("http")
//        URLProtocol.wk_registerScheme("https")
    }
    
    

    //加载页面
    open class func load(urlString: String) -> MLHybridViewController? {
        guard let url = URL(string: urlString.hybridUrlPathAllowedString()) else {return nil}
        let webViewController = MLHybridViewController()
        webViewController.urlPath = url
        return webViewController        
    }
    
    open class func updateSession(sess:String){
        shared.sess = sess
    }

    //版本检测并更新
    open class func checkVersion() {
        MLHybridTools().checkVersion()
    }
}
