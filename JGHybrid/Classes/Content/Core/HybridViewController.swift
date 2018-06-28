//
//  MLHybridViewController.swift
//  Pods
//

import UIKit
import WebKit

//更换类名 兼容老版本
public typealias MLHybridViewController = HybridViewController

open class HybridViewController: UIViewController,UIScrollViewDelegate,WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler  {
    
    //MARK: 设置属性
    /// 是否隐藏 NavigationBar
    public var naviBarHidden = false {
        didSet {
            self.navigationController?.setNavigationBarHidden(self.naviBarHidden, animated: true)
        }
    }
    
    /// 是否需要返回按钮: false 为系统默认
    public var needBackButton = false
    
    /// 是否需要隐藏 NavigationBottomBar
    public var needHidesBottomBar = true
    
    /// 是否需要模拟大标题
    public var needLargeTitle = false
    
    /// 是否需要加载进度
    public var needLoadProgress = false
    
    /// 标题颜色
    public var titleColor:UIColor = MLHybridConfiguration.default.defaultTitleColor {               //Title颜色
        didSet {
            self.largeTitleLabel?.textColor = self.titleColor
            self.navigationController?.navigationBar.hybridSetTitleColor(self.titleColor)
        }
    }
    
    /// 标题背景色
    public var titleBackgroundColor:UIColor = MLHybridConfiguration.default.defaultTitleBackgroundTColor{      //Title背景色
        didSet {
            self.largeTitleView?.backgroundColor = self.titleBackgroundColor
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
            self.largeTitleLabel?.text = titleName
        }
    }
    //状态栏
    public var statusBarStyle: UIStatusBarStyle? {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    //是否全屏
    public var isFullScreen:Bool = false
    
    //MARK: 视图控件
    public var contentView: MLHybridContentView!
    
    public var progressView:UIProgressView!
    
    public var largeTitleView:UIView?
    
    public var largeTitleLabel:UILabel?
    
    public var largeTitleViewTop: NSLayoutConstraint!
    
    public var largeTitleViewHeight:CGFloat = 74.5
    //MARK: 控制器数据
    //回调相关变量
    public var onShowCallBack: String?
    
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
    
    //上一个控制器的NavigationBar的颜色
    var upNavigationBarBackgroundColor:UIColor?
    
    //上一个控制器的NavigationBar是否隐藏
    var upNavigationBarIsHide:Bool?
    
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

