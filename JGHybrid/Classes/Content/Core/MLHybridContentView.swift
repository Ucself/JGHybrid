
//
//  MLHybridWebView.swift
//  Pods
//

import UIKit
import CoreMotion
import JavaScriptCore
import WebKit

open class MLHybridContentView: WKWebView {

    static var sharedKPreferences = WKPreferences()
    static var sharedProcessPool = WKProcessPool()
    
    let tool: MLHybridTools = MLHybridTools()
    //待注入的字符串
    public var htmlString: String?
    //注入对象
    //let swiftJavaScriptModel:Hybrid_swiftJavaScriptModel = Hybrid_swiftJavaScriptModel.init()

//    private override init(frame: CGRect) {
//        super.init(frame: frame)
//        initUI()
//        configUserAgent()
//        customerCookie()
//        NotificationCenter.default.addObserver(forName: MLHybridNotification.updateCookie, object: nil, queue: nil) { [weak self] (notification) in
//            self?.customerCookie()
//        }
//    }
    
    public convenience init(frame: CGRect) {
        let configuration = WKWebViewConfiguration()
        configuration.preferences = MLHybridContentView.sharedKPreferences
        configuration.preferences.minimumFontSize = 10;
        // 默认认为YES
        configuration.preferences.javaScriptEnabled = true;
        // 在iOS上默认为NO，表示不能自动通过窗口打开
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = false;
        configuration.processPool = MLHybridContentView.sharedProcessPool
        let  userContentController = WKUserContentController()
        let cookieValue = "document.cookie ='platform=\(MLHybrid.shared.platform);path=/;domain=\(MLHybrid.shared.domain);expires=Sat, 02 May 2019 23:38:25 GMT；';document.cookie = 'sess=\(MLHybrid.shared.sess);path=/;domain=\(MLHybrid.shared.domain);expires=Sat, 02 May 2019 23:38:25 GMT；';"
        let  cookieScript = WKUserScript(source: cookieValue, injectionTime: .atDocumentStart , forMainFrameOnly: false)
        userContentController.addUserScript(cookieScript)
        configuration.userContentController = userContentController
        self.init(frame: frame, configuration: configuration)
    }
    
    private override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame:frame,configuration:configuration)
        self.initUI()
        configUserAgent()
        customerCookie()
        NotificationCenter.default.addObserver(forName: MLHybridNotification.updateCookie, object: nil, queue: nil) { [weak self] (notification) in
            self?.customerCookie()
        }
        self.uiDelegate = self
        self.navigationDelegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func initUI () {
        self.backgroundColor = UIColor.white
        self.scrollView.bounces = false
        self.translatesAutoresizingMaskIntoConstraints = false
        //self.delegate = self
        self.uiDelegate = self
        self.navigationDelegate = self
    }

    //设置userAgent
    func configUserAgent () {
        
        //设置userAgent  webview
        var userAgentStr: String = UIWebView().stringByEvaluatingJavaScript(from: "navigator.userAgent") ?? ""
        if (userAgentStr.range(of: MLHybrid.shared.userAgent) == nil) {
            guard let versionStr = Bundle.main.infoDictionary?["CFBundleShortVersionString"] else {return}
            userAgentStr.append(" \(MLHybrid.shared.userAgent)\(versionStr) ")
            UserDefaults.standard.register(defaults: ["UserAgent" : userAgentStr])
        }
        
    }

    //注入cookie
    func customerCookie() {
        setCookie(value: MLHybrid.shared.sess, key: "sess")
        setCookie(value: MLHybrid.shared.platform, key: "platform")
    }

    func setCookie(value: String, key: String) {
        var properties = [HTTPCookiePropertyKey: Any]()
        properties.updateValue(HTTPCookiePropertyKey(rawValue: value), forKey: HTTPCookiePropertyKey(rawValue: HTTPCookiePropertyKey.value.rawValue))
        properties.updateValue(HTTPCookiePropertyKey(rawValue: key), forKey: HTTPCookiePropertyKey(rawValue: HTTPCookiePropertyKey.name.rawValue))
        properties.updateValue(HTTPCookiePropertyKey(rawValue: MLHybrid.shared.domain) as AnyObject, forKey: HTTPCookiePropertyKey(rawValue: HTTPCookiePropertyKey.domain.rawValue))
        properties.updateValue(Date(timeIntervalSinceNow: 60*60*3600) as AnyObject, forKey: HTTPCookiePropertyKey(rawValue: HTTPCookiePropertyKey.expires.rawValue))
        properties.updateValue("/" as Any, forKey: HTTPCookiePropertyKey(rawValue: HTTPCookiePropertyKey.path.rawValue))
        let cookie = HTTPCookie(properties: properties )
        HTTPCookieStorage.shared.setCookie(cookie!)
    }
    
}

extension MLHybridContentView: UIWebViewDelegate {
    
    /*func vcOfView(view: UIView) -> MLHybridViewController {
        var nextResponder = view.next
        while !(nextResponder is MLHybridViewController) {
            nextResponder = nextResponder?.next ?? UIViewController()
        }
        return nextResponder as? MLHybridViewController ?? MLHybridViewController()
    }

    public func webViewDidFinishLoad(_ webView: UIWebView) {
        /*
        if self.scrollView.mj_header != nil {
            self.scrollView.mj_header?.endRefreshing()
        }
        */
        if let title = webView.stringByEvaluatingJavaScript(from: "document.title"), title.characters.count > 0 {
            self.vcOfView(view: webView).title = title
        }
        if let htmlString = self.htmlString {
            let js = "var string = '\(htmlString)', style = string.match(/<style(?:.*)>(.*)<\\/style>/i) || [], script = string.match(/<script(?:.*)>(.*)<\\/script>/i) || []; if (style[1]){var styleEle = document.createElement('style'); styleEle.innerHTML = style[1]; document.head.appendChild(styleEle)};if (script[1]){var scriptEle = document.createElement('script'); scriptEle.innerHTML = script[1]; document.body.appendChild(scriptEle)}"
            webView.stringByEvaluatingJavaScript(from: js)
            self.htmlString = nil
        }
        //注入js方法
        self.swiftJavaScriptModel.jsContext = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext
        self.swiftJavaScriptModel.webView = webView
        self.swiftJavaScriptModel.jsContext?.setObject(self.swiftJavaScriptModel, forKeyedSubscript: "hybird" as NSCopying & NSObjectProtocol)
    }
    
    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if self.tool.performCommand(request: request, webView: webView) {
            return false
        }
        return true
    }*/
    
}
extension MLHybridContentView: WKUIDelegate,WKNavigationDelegate {
    
    func vcOfView(view: UIView) -> MLHybridViewController {
        var nextResponder = view.next
        while !(nextResponder is MLHybridViewController) {
            nextResponder = nextResponder?.next ?? UIViewController()
        }
        return nextResponder as? MLHybridViewController ?? MLHybridViewController()
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        
        self.vcOfView(view: webView).title = webView.title
        
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
