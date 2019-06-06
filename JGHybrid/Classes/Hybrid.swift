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
    public static let shared = MLHybrid()
    private override init() {}
    //私有变量
    var delegate: MLHybridMethodProtocol?
    //初始化注册
    open class func register(_ delegate: MLHybridMethodProtocol) {
        shared.delegate = delegate
        //设置拦截
        if HybridConfiguration.default.isRegisterURLProtocol {
            URLProtocol.registerClass(MLHybridURLProtocol.self)
            URLProtocol.wk_registerScheme("http")
            URLProtocol.wk_registerScheme("https")
        }
        //解压压缩包
        if HybridConfiguration.default.isCacheHtml {
            HybridCacheManager.default.HybridUnzipHybiryOfflineZip()
        }
    }
    //加载页面 taroH5 url中含有‘#’符号，只进行utf-8转码即可
    open class func load(urlString: String, taroH5:Bool=false) -> MLHybridViewController? {
        let webViewController = MLHybridViewController()
        let charSet = CharacterSet.urlQueryAllowed as NSCharacterSet
        let mutSet = charSet.mutableCopy() as! NSMutableCharacterSet
        mutSet.addCharacters(in: "#")
        let url:URL? = URL.init(string: urlString.addingPercentEncoding(withAllowedCharacters: mutSet as CharacterSet) ?? "")
        webViewController.urlPath = url
        return webViewController
    }
    
    //新的zip包版本检测
    open class func checkOfflinePackage() {
        MLHybridCommandExecute().hybridOfflinePackage()
    }
}


