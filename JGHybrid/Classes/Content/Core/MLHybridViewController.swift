//
//  MLHybridViewController.swift
//  Pods
//

import UIKit
import WebKit

open class MLHybridViewController: UIViewController {
    
    //MARK: 公共参数
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
    public var titleColor:UIColor = MLHybridConfiguration.default.defaultTitleColor{               //Title颜色
        didSet {
            self.largeTitleLabel?.textColor = self.titleColor
            self.navigationController?.navigationBar.setTitleColor(self.titleColor)
        }
    }
    
    /// 标题背景色
    public var titleBackgroundColor:UIColor = MLHybridConfiguration.default.defaultTitleBackgroundTColor{      //Title背景色
        didSet {
            self.largeTitleView?.backgroundColor = self.titleBackgroundColor
            self.navigationController?.navigationBar.setBackgroundColor(self.titleBackgroundColor)
        }
    }
    
    /// 标题
    public var titleName:String = "" {
        didSet {
            self.title = titleName
            self.largeTitleLabel?.text = titleName
        }
    }
    //MARK: 私有参数
    //视图控件
    var progressView:UIProgressView!
    var contentView: MLHybridContentView!
    var largeTitleView:UIView?
    var largeTitleLabel:UILabel?
    var largeTitleViewTop: NSLayoutConstraint!
    var largeTitleViewHeight:CGFloat = 74.5
    //回调相关变量
    var urlPath: URL?
    var onShowCallBack: String?
    var onHideCallBack: String?
    
    /// Hybrid js默认回调函数
    var hybridEvent = "Hybrid.callback"
    
    /// 定位对象
    var locationModel = MLHybridLocation()
    
    /// 执行命令对象
    var tool: MLHybirdCommandExecute = MLHybirdCommandExecute()
    
    //MARK: 系统方法
    deinit {
        locationModel.stopUpdateLocation()
        if contentView != nil {
            contentView.load(URLRequest(url: URL(string: "about:blank")!))
            contentView.stopLoading()
            contentView.removeFromSuperview()
            contentView = nil
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
        //加载等待
        MLHybridConfiguration.default.startWait()
        //设置导航栏
        self.navigationController?.setNavigationBarHidden(naviBarHidden, animated: true)
        //js方法注入
        self.contentView?.configuration.userContentController.add(self, name: "requestHybrid")
        //添加wkwebview监听
        self.contentView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
        //回调Hybrid
        if let callback = self.onShowCallBack {
            self.tool.callBack(data: "", err_no: 0, msg: "onwebviewshow", callback: callback, webView: self.contentView, completion: {js in })
        }
        //设置颜色
        self.navigationController?.navigationBar.setTitleColor(self.titleColor)
        self.navigationController?.navigationBar.setBackgroundColor(self.titleBackgroundColor)
        self.largeTitleView?.backgroundColor = self.titleBackgroundColor
        self.largeTitleLabel?.textColor = self.titleColor
        
        //不需要自动边距
        if #available(iOS 11.0, *) {
            self.contentView.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //取消方法注入
        self.contentView?.configuration.userContentController.removeScriptMessageHandler(forName: "requestHybrid")
        //移除KVO
        self.contentView.removeObserver(self, forKeyPath: "estimatedProgress")
        //回调Hybrid
        if let callback = self.onHideCallBack {
            let _ =  self.tool.callBack(data: "", err_no: 0, msg: "onwebviewshow", callback: callback, webView: self.contentView, completion: {js in })
        }
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate;
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    open override  func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
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
    
    //MARK: 自定义方法
    func initUI() {
        self.hidesBottomBarWhenPushed = needHidesBottomBar
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.setUpBackButton()
    }
    
    func initContentView() {
        //设置大标题
        if !self.needLargeTitle {
            //设置约束高度
            self.largeTitleViewHeight = 0
            self.title = self.titleName
        }
        else {
            self.largeTitleViewHeight = 74.5
            self.title = ""
        }
        //容器数据对象
        self.contentView = MLHybridContentView()
        self.largeTitleView = UIView.init()
        self.largeTitleView?.backgroundColor = self.titleBackgroundColor
        self.view.addSubview(self.contentView)
        self.view.addSubview(self.largeTitleView!)
        //Title
        self.largeTitleLabel = UILabel.init()
        self.largeTitleLabel!.font = UIFont.init(name: "PingFangSC-Medium", size: 22)
        self.largeTitleLabel!.textColor = self.titleColor
        self.largeTitleLabel!.text = self.titleName
        self.largeTitleView!.addSubview(self.largeTitleLabel!)
        //约束变量
        self.largeTitleView!.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.largeTitleLabel!.translatesAutoresizingMaskIntoConstraints = false
        let topGuide = self.topLayoutGuide
        let bottomGuide = self.bottomLayoutGuide
        //大标题Label布局
        let leftTitleLabelConstraint = NSLayoutConstraint(item: self.largeTitleLabel!, attribute: .left, relatedBy: .equal, toItem: self.largeTitleView, attribute: .left, multiplier: 1.0, constant: 22)
        let rightTitleLabelConstraint = NSLayoutConstraint(item: self.largeTitleLabel!, attribute: .right, relatedBy: .equal, toItem: self.largeTitleView, attribute: .right, multiplier: 1.0, constant: 0)
        let topTitleLabelConstraint = NSLayoutConstraint(item: self.largeTitleLabel!, attribute: .top, relatedBy: .equal, toItem: self.largeTitleView, attribute: .top, multiplier: 1.0, constant: 0)
        let bottomTitleLabelConstraintt = NSLayoutConstraint(item: self.largeTitleLabel!, attribute: .bottom, relatedBy: .equal, toItem: self.largeTitleView, attribute: .bottom, multiplier: 1.0, constant: 0)
        //大标题布局
        let leftLargeTitleConstraint = NSLayoutConstraint(item: self.largeTitleView!, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0)
        let rightLargeTitleConstraint = NSLayoutConstraint(item: self.largeTitleView!, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0)
        let topLargeTitleConstraint = NSLayoutConstraint(item: self.largeTitleView!, attribute: .top, relatedBy: .equal, toItem: topGuide, attribute: .bottom, multiplier: 1.0, constant: 0)
        let heightLargeTitleConstrain = NSLayoutConstraint(item: self.largeTitleView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.largeTitleViewHeight)
        self.largeTitleViewTop = topLargeTitleConstraint
        //容器布局
        let leftConstraint = NSLayoutConstraint(item: self.contentView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: self.contentView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0)
        let topConstraint = NSLayoutConstraint(item: self.contentView, attribute: .top, relatedBy: .equal, toItem: self.largeTitleView, attribute: .bottom, multiplier: 1.0, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: self.contentView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        self.view.addConstraints([leftTitleLabelConstraint,rightTitleLabelConstraint,topTitleLabelConstraint,bottomTitleLabelConstraintt,
                                  leftLargeTitleConstraint,rightLargeTitleConstraint,topLargeTitleConstraint,heightLargeTitleConstrain,
                                  leftConstraint,rightConstraint,topConstraint,bottomConstraint])
        
        //设置代理
        self.contentView.uiDelegate = self
        self.contentView.navigationDelegate = self
        self.contentView.scrollView.delegate = self
        //加载
        guard urlPath != nil else {return}
        var urlRequest:URLRequest = URLRequest.init(url: urlPath!)
        urlRequest.setValue(MLHybridConfiguration.default.cookieString, forHTTPHeaderField: MLHybridConfiguration.default.cookieName)
        self.contentView.load(urlRequest)
    }
    
    func initProgressView() {
        self.progressView = UIProgressView.init(progressViewStyle: .default)
        self.progressView.progressTintColor = UIColor.blue
        self.progressView.trackTintColor = UIColor.clear
        self.progressView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 3)
        //添加进度条
        if self.needLoadProgress {
            self.view.addSubview(self.progressView)
        }
        
    }
    
    //初始化控件数据
    func initData(){
        //设置userAgent
        self.contentView.evaluateJavaScript("navigator.userAgent") { [weak self](result, error) in
            //获取userAgent数据
            guard let weakSelf = self,var userAgentStr:String = result as? String else { return }
            //查看是否设置过
            guard userAgentStr.range(of: MLHybridConfiguration.default.userAgent) == nil else { return }
            //未获取到版本
            guard let versionStr = Bundle.main.infoDictionary?["CFBundleShortVersionString"] else {return}
            userAgentStr.append(" \(MLHybridConfiguration.default.userAgent)\(versionStr) ")
            userAgentStr.append(" Hybrid/\(versionStr) ")
            if #available(iOS 9.0, *) {
                weakSelf.contentView.customUserAgent = userAgentStr
            } else {
                // Fallback on earlier versions
                UserDefaults.standard.register(defaults: ["UserAgent" : userAgentStr])
            }
        }
        //设置拦截
        if MLHybridConfiguration.default.isRegisterURLProtocol {
            URLProtocol.wk_registerScheme("http")
            URLProtocol.wk_registerScheme("https")
        }
    }
    
    func setUpBackButton() {
        //如果初始化不需要返回按钮
        if !self.needBackButton {
            return
        }
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 42, height: 44)
        button.addTarget(self, action: #selector(self.backButtonClick), for: .touchUpInside)
        let image = UIImage(named: MLHybridConfiguration.default.backIndicator)
        button.setImage(image, for: .normal)
        button.contentHorizontalAlignment = .left
        let item = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = item
    }
    
    @objc func backButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK: 模拟大标题 功能 UIScrollViewDelegate
extension MLHybridViewController:UIScrollViewDelegate {
    //位置变化回调
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let newY = largeTitleViewTop.constant - scrollView.contentOffset.y
        largeTitleViewTop.constant = newY < -largeTitleViewHeight ? -largeTitleViewHeight : (newY > 0 ? 0 : newY)
        _adjustTitleTopConstant(largeTitleViewTop.constant)
        if scrollView.frame.origin.y > 0.0 && scrollView.frame.origin.y < largeTitleViewHeight {
            if scrollView.isDragging {
                scrollView.contentOffset = CGPoint.zero
            }
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        _adjustContentOffset(scrollView)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            _adjustContentOffset(scrollView)
        }
    }
    //调整回弹
    private func _adjustContentOffset(_ scrollView: UIScrollView) {
        
        let current = largeTitleViewTop.constant
        if current < -largeTitleViewHeight / 2 && current > -largeTitleViewHeight {
            largeTitleViewTop.constant = -largeTitleViewHeight
            _adjustTitleTopConstant(largeTitleViewTop.constant)
        } else if current >= -largeTitleViewHeight / 2 && current < 0 {
            largeTitleViewTop.constant = 0
            _adjustTitleTopConstant(largeTitleViewTop.constant)
        }
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }
    //根据顶部常量设置Title
    private func _adjustTitleTopConstant(_ topConstant:CGFloat){
        let current = topConstant
        if current < -largeTitleViewHeight / 2 && current > -largeTitleViewHeight {
            //大标题显示大部分的时候
            self.title = self.titleName
        } else if current >= -largeTitleViewHeight / 2 && current < 0 {
            //大标题隐藏大部分的时候
            self.title = ""
        }
    }
}

//MARK: WKUIDelegate WKNavigationDelegate
extension MLHybridViewController: WKUIDelegate,WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        //加载等待结束
        MLHybridConfiguration.default.stopWait()
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if self.tool.performCommand(request: navigationAction.request, webView: webView) {
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    public func webViewWebContentProcessDidTerminate(_ webView: WKWebView){
        webView.reload()
    }
    
}
//MARK:WKScriptMessageHandler
extension MLHybridViewController:WKScriptMessageHandler {
    //MessageHandler 回调
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        //判断是否是requestHybrid 命令
        guard message.name == "requestHybrid"  else {  return }
        //判断是否符合参数
        guard let commandDic:Dictionary<String,Any> = message.body as? Dictionary<String,Any> else { return }
        
        //Hybird命令对象
        let command:MLHybirdCommand = MLHybirdCommand()
        
        //判断是否有tagname
        if let name = commandDic["name"] as? String {
            command.name = name
        }
        if let params = commandDic["params"] as? [String: AnyObject] {
            command.params = params
            //转换为内部使用参数
            //let args = MLHybirdCommandParams.convert(params)   //旧的解析方式
            let args = MLHybirdCommandParams.convert(params, nameType: MLHybridMethodType(rawValue:command.name))
            command.args = args
        }
        if let callback = commandDic["callback"] as? String {
            command.callbackId = callback
        }
        command.webView = self.contentView
        command.viewController = self
        tool.command = command
        _ = tool.performCommand(command: command)
    }
}

