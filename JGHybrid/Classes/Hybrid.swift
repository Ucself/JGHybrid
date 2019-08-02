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
    public static let shared = Hybrid()
    private override init() {}
    //私有变量
    var delegate: HybridMethodProtocol?
    //初始化注册
    open class func register(_ delegate: HybridMethodProtocol) {
        shared.delegate = delegate
        //设置拦截
        if HybridConfiguration.default.isRegisterURLProtocol {
            URLProtocol.registerClass(HybridURLProtocol.self)
            URLProtocol.wk_registerScheme("http")
            URLProtocol.wk_registerScheme("https")
        }
        //解压压缩包
        if HybridConfiguration.default.isCacheHtml {
            HybridCacheManager.default.HybridUnzipHybiryOfflineZip()
        }
    }
    //加载页面
    open class func load(urlString: String) -> HybridViewController? {
        let webViewController = HybridViewController()
        let charSet = CharacterSet.urlQueryAllowed as NSCharacterSet
        let mutSet = charSet.mutableCopy() as! NSMutableCharacterSet
        mutSet.addCharacters(in: "#")
        let url:URL? = URL.init(string: urlString.addingPercentEncoding(withAllowedCharacters: mutSet as CharacterSet) ?? "")
        webViewController.urlPath = url
        return webViewController
    }
    
    //新的zip包版本检测
    open class func checkOfflinePackage() {
        HybridCommandExecute().hybridOfflinePackage()
    }
}


