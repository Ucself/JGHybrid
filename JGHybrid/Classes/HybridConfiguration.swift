//
//  MLHybridConfiguration.swift
//  JGHybrid
//
//  Created by 李保君 on 2017/12/5.
//

import UIKit


//更换类名 兼容老版本
public typealias MLHybridConfiguration = HybridConfiguration
/// Hybrid 配置类
open class HybridConfiguration: NSObject {
    /// 单例对象
    public static let `default` = MLHybridConfiguration()
    private override init() {}
    
    //MARK: -- 离线包相关配置
    /// 是否注册Protocol拦截
    open var isRegisterURLProtocol:Bool = false
    
    /// 是否拦截换成Html地址
    open var isCacheHtml:Bool = false
    
    /// 获取的缓存文件地址
    open var cacheURLString:String = "http://web-dev.doctorwork.com/app/health/manifest.json"
    
    /// 离线包html需要解析的地址
    open var cacheMap: [String] = ["/app/health","/rapp/health"]
    
    //MARK: -- http配置相关
    /// userAgent
    open var userAgent:String = ""
    
    /// scheme
    open var scheme:String = "docheathhybrid"
    
    //MARK: -- UI配置相关
    /// 返回按钮图片名称
    open var backIndicator:String = "backButton"
    
    /// 导航栏图片前缀
    open var naviImagePrefixes:String = "hybrid_navi_"
    
    /// 默认标题颜色
    open var defaultTitleColor:UIColor = UIColor.hybridColorWithHex("2F2929")
    
    /// 默认标题背景颜色
    open var defaultTitleBackgroundTColor:UIColor = UIColor.white
    
    /// pageShow 回调字符串，h5临时要求
    open var pageShowEvent:String = "Hybrid.event('pageshow')"
    
    /// 离线包json地址
    open var offlinePackageJsonUrl:String = "http://web-dev.doctorwork.com/ios/resources.json"
    
}
