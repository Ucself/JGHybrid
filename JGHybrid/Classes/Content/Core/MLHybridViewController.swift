//
//  MLHybridViewController.swift
//  Pods
//

import UIKit
import NJKWebViewProgress
import WebKit

open class MLHybridViewController: UIViewController {

    var locationModel = MLHybridLocation()
    public var needSetHeader = true
    public var naviBarHidden = false
    public var URLPath: URL?
    public var htmlString: String?
    var onShowCallBack: String?
    var onHideCallBack: String?
    public var contentView: MLHybridContentView!

    var _webViewProgressView = NJKWebViewProgressView()
    let _webViewProgress = NJKWebViewProgress()

    //MARK: - init
    deinit {
        locationModel.stopUpdateLocation()
        if contentView != nil {
            //contentView.loadRequest(URLRequest(url: URL(string: "about:blank")!))
            //contentView.load(URLRequest(url: URL(string: "about:blank")!))
            contentView.stopLoading()
            contentView.removeFromSuperview()
            contentView = nil
        }
    }
    
    //MARK: - life cycle
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
        
        if let callback = self.onShowCallBack {
            MLHybridTools().callBack(data: "", err_no: 0, msg: "onwebviewshow", callback: callback, webView: self.contentView, completion: {js in })
        }
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //取消方法注入
        self.contentView?.configuration.userContentController.removeScriptMessageHandler(forName: "requestHybrid")
        if let callback = self.onHideCallBack {
            let _ =  MLHybridTools().callBack(data: "", err_no: 0, msg: "onwebviewshow", callback: callback, webView: self.contentView, completion: {js in })
        }
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate;
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    //MARK: - Method
    func initUI() {
        self.hidesBottomBarWhenPushed = true
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = naviBarHidden
        self.setUpBackButton()
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
    
    func initProgressView() {
        //contentView.delegate = _webViewProgress
        _webViewProgress.webViewProxyDelegate = contentView;
        _webViewProgress.progressDelegate = self;
        
        let navBounds = self.navigationController?.navigationBar.bounds
        let barFrame = CGRect(x: 0, y: (navBounds?.size.height ?? 0) - 2, width: navBounds?.size.width ?? 0, height: 2)
        _webViewProgressView = NJKWebViewProgressView(frame: barFrame)
        _webViewProgressView.setProgress(0, animated: true)
        self.navigationController?.navigationBar.addSubview(_webViewProgressView)
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
        guard URLPath != nil else {return}
        //self.contentView.loadRequest(URLRequest(url: URLPath!))
        self.contentView.load(URLRequest(url: URLPath!))
    }
}

extension MLHybridViewController: NJKWebViewProgressDelegate {
    public func webViewProgress(_ webViewProgress: NJKWebViewProgress!, updateProgress progress: Float) {
        _webViewProgressView.setProgress(progress, animated: true)
//        if progress > 0.7 {
//            _webViewProgressView.setProgress(progress, animated: true)
//        } else {
//            _webViewProgressView.setProgress(0.7, animated: true)
//        }
    }
    
    open func setProgress(_ progress: Float) {
        _webViewProgressView.setProgress(progress, animated: true)
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
