//
//  MLHybridViewController.swift
//  Pods
//

import UIKit
import WebKit

open class MLHybridViewController: UIViewController {

    //MARK: 公共参数
    public var needSetHeader = true
    public var naviBarHidden = false
    public var URLPath: URL?
    public var htmlString: String?
    public var contentView: MLHybridContentView!
    //MARK: 私有参数
    var locationModel = MLHybridLocation()
    let tool: MLHybridTools = MLHybridTools()
    var onShowCallBack: String?
    var onHideCallBack: String?
    var progressView:UIProgressView!
    
    //MARK: 系统方法
    deinit {
        locationModel.stopUpdateLocation()
        if contentView != nil {
            //contentView.loadRequest(URLRequest(url: URL(string: "about:blank")!))
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
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //js方法注入
        self.contentView?.configuration.userContentController.add(self, name: "requestHybrid")
        //添加wkwebview监听
        self.contentView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
        //回调Hybrid
        if let callback = self.onShowCallBack {
            MLHybridTools().callBack(data: "", err_no: 0, msg: "onwebviewshow", callback: callback, webView: self.contentView, completion: {js in })
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
            let _ =  MLHybridTools().callBack(data: "", err_no: 0, msg: "onwebviewshow", callback: callback, webView: self.contentView, completion: {js in })
        }
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate;
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    open override  func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let observeObject:MLHybridContentView = object as? MLHybridContentView {
            guard keyPath == "estimatedProgress" && observeObject == self.contentView else { return }
//            //加载到导航栏下面
//            var topY = 0.0
//            if !UIApplication.shared.isStatusBarHidden {
//                topY = topY + Double(UIApplication.shared.statusBarFrame.size.height)
//            }
//            if self.navigationController != nil, !(self.navigationController?.isNavigationBarHidden)! {
//                topY = topY + Double(self.navigationController!.navigationBar.frame.size.height)
//            }
//            self.progressView.frame = CGRect.init(x: 0.0, y: topY, width: Double(self.view.frame.size.width), height: 3)
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
        self.hidesBottomBarWhenPushed = true
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = naviBarHidden
        self.setUpBackButton()
    }

    func initContentView() {
        self.contentView = MLHybridContentView()
        self.view.addSubview(self.contentView)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraint = NSLayoutConstraint(item: self.contentView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0)
        self.view.addConstraint(leftConstraint)
        let rightConstraint = NSLayoutConstraint(item: self.contentView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0)
        self.view.addConstraint(rightConstraint)
        let topGuide = self.topLayoutGuide
        let topConstraint = NSLayoutConstraint(item: self.contentView, attribute: .top, relatedBy: .equal, toItem: topGuide, attribute: .bottom, multiplier: 1.0, constant: 0)
        self.view.addConstraint(topConstraint)
        let bottomConstraint = NSLayoutConstraint(item: self.contentView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0)
        self.view.addConstraint(bottomConstraint)
        
        if let htmlString = self.htmlString {
            self.contentView.htmlString = htmlString
        }
        self.contentView.uiDelegate = self
        self.contentView.navigationDelegate = self
        
        guard URLPath != nil else {return}
        //self.contentView.loadRequest(URLRequest(url: URLPath!))
        self.contentView.load(URLRequest(url: URLPath!))
    }
    
    func initProgressView() {
        self.progressView = UIProgressView.init(progressViewStyle: .default)
        self.progressView.progressTintColor = UIColor.blue
        self.progressView.trackTintColor = UIColor.clear
        self.progressView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 3)
        self.view.addSubview(self.progressView)
        
    }
    
    func setUpBackButton() {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 42, height: 44)
        button.addTarget(self, action: #selector(MLHybridViewController.back), for: .touchUpInside)
        let image = UIImage(named: MLHybrid.shared.backIndicator)
        button.setImage(image, for: .normal)
        button.contentHorizontalAlignment = .left
        let item = UIBarButtonItem(customView: button)
        self.navigationItem.setLeftBarButton(item, animated: true)
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}


extension MLHybridViewController: WKUIDelegate,WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        
        if let htmlString = self.htmlString {
            webView.evaluateJavaScript("document.body.innerHTML = document.body.innerHTML + '\(htmlString)'", completionHandler: { (any, error) in })
            self.htmlString = nil
        }
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

extension MLHybridViewController:WKScriptMessageHandler {
    //MessageHandler 回调
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        //判断是否是requestHybrid 命令
        guard message.name == "requestHybrid"  else {  return }
        //判断是否符合参数
        guard let commandDic:Dictionary<String,Any> = message.body as? Dictionary<String,Any> else { return }
        
        //Hybird命令对象
        let command:MLHybirdCommand = MLHybirdCommand()
        //Hybird执行工具对象
        let tool: MLHybridTools = MLHybridTools()
        
        //判断是否有tagname
        if let name = commandDic["name"] as? String {
            command.name = name
        }
        if let params = commandDic["param"] as? [String: AnyObject] {
            command.params = params
            //转换为内部使用参数
            let args = MLCommandArgs.convert(params)
            command.args = args
        }
        command.webView = self.contentView
        tool.command = command
        _ = tool.performCommand(command: command)
    }
}
