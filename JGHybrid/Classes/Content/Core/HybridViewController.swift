//
//  MLHybridViewController.swift
//  Pods
//

import UIKit
import WebKit
import JGNavigationBarTransition

//更换类名 兼容老版本
public typealias MLHybridViewController = HybridViewController

open class HybridViewController: UIViewController,WKUIDelegate  {
    
    //MARK: --- 参数属性
    
    /// 是否需要返回按钮，默认false 系统会添加一个
    public var needBackButton = false
    
    /// 是否需要隐藏 NavigationBottomBar，项目结构不同
    public var needHidesBottomBar = true
    
    /// 是否需要加载进度
    public var needLoadProgress = true
    
    /// 是否需要业务加载符
    public var needStartWait = false
    
    //  是否导航栏透明
    public var needFullScreen:Bool = false
    
    //MARK: --- UI属性
    
    /// 标题颜色
    public var titleColor:UIColor = HybridConfiguration.default.navigationBarTitleColor {       //Title颜色
        didSet {
            self.jg_navBarTitleColor = self.titleColor
        }
    }
    
    /// 标题背景色
    public var barTintColor:UIColor = HybridConfiguration.default.navigationBarBarTintColor {      //Title背景色
        didSet {
            //全屏的话就不用设置需要的颜色
            if !needFullScreen {
                self.jg_navBarBarTintColor = self.barTintColor
            }
        }
    }
    
    /// 标题名称
    public var titleName:String = "" {
        didSet {
            self.navigationItem.title = titleName
        }
    }
    
    //MARK: --- UI视图控件
    
    /// WKWebView 容器
    public var contentView: HybridContentView!
    
    /// 加载进度条
    public var progressView:UIProgressView!
    
    //MARK: --- 控制器业务属性
    
    /// 控制器显示回调ID
    public var onShowCallBack: String?
    
    /// 控制器隐藏回调ID
    public var onHideCallBack: String?
    
    //webView 的URL
    public var urlPath: URL?
    
    /// 定位对象
    var locationModel = HybridLocation()
    
    /// 执行命令对象
    var commandExecute: HybridCommandExecute = HybridCommandExecute.init()
    
    //默认的userAgent
    var defaultUserAgent:String = "Mozilla/5.0 (iPhone; CPU iPhone OS 12_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/16A5318d JGHybrid/1.0.3"
    
    //键盘弹起屏幕偏移量
    var keyBoardPoint:CGPoint = CGPoint()
    
    deinit {
        locationModel.stopUpdateLocation()
        if self.contentView != nil {
            //取消方法注入
            self.contentView.configuration.userContentController.removeScriptMessageHandler(forName: "requestHybrid")
            self.contentView.load(URLRequest(url: URL(string: "about:blank")!))
            self.contentView.stopLoading()
            self.contentView.removeFromSuperview()
            self.contentView.uiDelegate = nil
            self.contentView.navigationDelegate = nil
            self.contentView.scrollView.delegate = nil
            self.contentView = nil
        }
    }
}

