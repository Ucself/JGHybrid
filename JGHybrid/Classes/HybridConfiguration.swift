//
//  HybridConfiguration.swift
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
    public static let `default` = HybridConfiguration()
    private override init() {}
    
    //MARK: -- 离线包相关配置
    /// 是否注册Protocol拦截
    var isRegisterURLProtocol:Bool = false
    
    /// 是否拦截换成Html地址
    var isCacheHtml:Bool = false
    
    /// 离线包html需要解析的地址
    var cacheMap: [String] = ["/app/health","/rapp/health"]
    
    /// 离线包json地址
    var offlinePackageJsonUrl:String = "http://web-dev.doctorwork.com/ios/resources.json"
    
    //MARK: -- http配置相关
    
    /// scheme
    var scheme:String = "docheathhybrid"
    
    /// 业务类名
    var apiClassName:String = "HybridBusiness"
    
    //MARK: - 全局配置
    
    /// 导航栏背景颜色
    open var navigationBarBarTintColor:UIColor = UIColor.white
    
    /// 导航栏标题颜色
    open var navigationBarTitleColor:UIColor = UIColor.black
    
    /// 导航栏主题颜色
    open var navigationBarTintColor:UIColor = UIColor.blue
    
    /// 导航栏透明度
    open var navigationBarBackgroundAlpha:CGFloat = 1.0
    
    /// 状态栏样式
    open var navigationBarStyle:UIStatusBarStyle = .default
    
    /// 阴影分割线隐藏
    open var navigationBarShadowImageHidden:Bool = false
    
    /// 注入 H5 带有的字符串 - userAgent
    open var userAgent:String = ""
    
    /// 默认返回按钮使用的图片名称
    open var backIndicator:String = "JGHybridImageNavBack"
    
    /// 使用图片的前缀
    open var imagePrefixes:String = "JGHybridImage"
    
    /// hybrid 默认回调js函数名称
    open var hybridEvent:String = "Hybrid.callback"
}

