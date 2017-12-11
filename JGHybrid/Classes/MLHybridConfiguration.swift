//
//  MLHybridConfiguration.swift
//  JGHybrid
//
//  Created by 李保君 on 2017/12/5.
//

import UIKit

/// Hybrid 配置类
open class MLHybridConfiguration: NSObject {
    /// 单例对象
    open static let `default` = MLHybridConfiguration()
    private override init() {}
    
    /// 是否开启日志
    open var openLog:Bool = true
    
    /// 获取的缓存文件地址
    open var cacheURLString:String = "http://web-dev.doctorwork.com/app/health/manifest.json"
    
    /// 登录后的session
    open var sess:String = "UnKnow"
    
    /// 传输给H5 的平台信息
    open var platform:String = "i"
    
    /// userAgent 新的解析方式已经弃用
    open var userAgent:String = "doc_hybrid_heath_"
    
    /// userAgent 新的解析方式已经弃用
    open var scheme:String = "docheathhybrid"
    
    /// 返回按钮图片名称
    open var backIndicator:String = "backButton"
    
    /// 导航栏图片前缀
    open var naviImagePrefixes:String = "hybrid_navi_"
}
