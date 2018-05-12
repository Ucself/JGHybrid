//
//  MLHybridViewController.swift
//  Pods
//

import UIKit
import WebKit

open class MLHybridViewController: UIViewController,UIScrollViewDelegate,WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler  {
    
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
    
    //MARK: 系统重写方法
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
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.initContentView()
        self.initProgressView()
        self.initData()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //设置导航栏
        self.navigationController?.setNavigationBarHidden(naviBarHidden, animated: true)
        //js方法注入
        //self.contentView?.configuration.userContentController.add(self, name: "requestHybrid")
        //添加wkwebview监听
        self.contentView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
        //回调Hybrid
        if let callback = self.onShowCallBack {
            self.commandExecute.command.callBack(data: "", err_no: 0, msg: "onwebviewshow", callback: callback, completion: {js in })
        }
        //设置颜色
        self.navigationController?.navigationBar.hybridSetTitleColor(self.titleColor)
        self.navigationController?.navigationBar.hybridSetBackgroundColor(self.titleBackgroundColor)
        self.view.backgroundColor = self.titleBackgroundColor
        self.largeTitleView?.backgroundColor = self.titleBackgroundColor
        self.largeTitleLabel?.textColor = self.titleColor
        
        //设置透明
        if self.isFullScreen {
            self.navigationController?.navigationBar.hybridSetBackgroundClear()
        }
        //临时要求的回调
        if self.pageFirstShow {
            self.pageFirstShow = false
        }
        else {
            self.commandExecute.command.webView.evaluateJavaScript(MLHybridConfiguration.default.pageShowEvent) { (result, error) in }
        }

    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //取消方法注入
        //self.contentView?.configuration.userContentController.removeScriptMessageHandler(forName: "requestHybrid")
        //移除KVO
        self.contentView.removeObserver(self, forKeyPath: "estimatedProgress")
        //回调Hybrid
        if let callback = self.onHideCallBack {
            let _ =  self.commandExecute.command.callBack(data: "", err_no: 0, msg: "onwebviewshow", callback: callback, completion: {js in })
        }
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate;
        //导航栏全屏透明的话就不要手势回退，有渐变bug
        if self.isFullScreen {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
        else {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let observeObject:MLHybridContentView = object as? MLHybridContentView {
            guard keyPath == "estimatedProgress" && observeObject == self.contentView else { return }
            //设置显示
            self.progressView.alpha = 1.0
            self.progressView.setProgress(Float(self.contentView.estimatedProgress), animated: true)
            //加载完成
            if self.contentView.estimatedProgress >= 1 {
                UIView.animate(withDuration: 0.3, delay: 0.3, options:.curveEaseInOut, animations: {
                    self.progressView.alpha = 0
                }, completion: { (finished) in
                    self.progressView.setProgress(0, animated: true)
                })
            }
        }
    }
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle ?? .default
    }
}

