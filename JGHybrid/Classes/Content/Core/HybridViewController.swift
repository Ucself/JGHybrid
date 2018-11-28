//
//  MLHybridViewController.swift
//  Pods
//

import UIKit
import WebKit

//更换类名 兼容老版本
public typealias MLHybridViewController = HybridViewController

open class HybridViewController: UIViewController,UIScrollViewDelegate,WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler  {
    
    //MARK: --- 参数属性
    
    /// 是否隐藏
    public var naviBarHidden = false {
        didSet {
            self.navigationController?.setNavigationBarHidden(self.naviBarHidden, animated: true)
        }
    }
    
    /// 是否需要返回按钮
    public var needBackButton = false
    
    /// 是否需要隐藏 NavigationBottomBar
    public var needHidesBottomBar = true
    
    /// 是否需要加载进度
    public var needLoadProgress = false
    
    /// 是否需要业务加载符
    public var needStartWait = true
    
    //  是否导航栏透明
    public var isFullScreen:Bool = false
    
    /// 是否导航栏透明返回手势
    public var needFullScreenBackGestures = false
    
    //MARK: --- UI属性
    
    /// 标题颜色
    public var titleColor:UIColor = MLHybridConfiguration.default.defaultTitleColor {               //Title颜色
        didSet {
            self.navigationController?.navigationBar.hybridSetTitleColor(self.titleColor)
        }
    }
    
    /// 标题背景色
    public var titleBackgroundColor:UIColor = MLHybridConfiguration.default.defaultTitleBackgroundTColor{      //Title背景色
        didSet {
            //全屏的话就不用设置需要的颜色
            if self.isFullScreen {
                self.navigationController?.navigationBar.hybridSetBackgroundClear()
            }
            else {
                self.navigationController?.navigationBar.hybridSetBackgroundColor(self.titleBackgroundColor)
            }
        }
    }
    
    /// 标题
    public var titleName:String = "" {
        didSet {
            self.navigationItem.title = titleName
        }
    }
    //状态栏
    public var statusBarStyle: UIStatusBarStyle? {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    //MARK: --- UI视图控件
    
    /// WKWebView 容器
    public var contentView: MLHybridContentView!
    
    /// 加载精度条
    public var progressView:UIProgressView!
    
    //MARK: --- 控制器业务属性
    
    /// 控制器显示回调ID
    public var onShowCallBack: String?
    
    /// 控制器隐藏回调ID
    public var onHideCallBack: String?
    
    //webView 的URL
    public var urlPath: URL?
    
    /// Hybrid js默认回调函数
    public var hybridEvent = "Hybrid.callback"
    
    /// 定位对象
    var locationModel = MLHybridLocation()
    
    /// 执行命令对象
    var commandExecute: MLHybirdCommandExecute = MLHybirdCommandExecute()
    
    /// H5需要不是第一次显示的回调
    var pageFirstShow = true
    
    //默认的userAgent
    var defaultUserAgent:String = "Mozilla/5.0 (iPhone; CPU iPhone OS 12_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/16A5318d doc_hybrid_heath_1.0.3  Hybrid/1.0.3"
    
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

