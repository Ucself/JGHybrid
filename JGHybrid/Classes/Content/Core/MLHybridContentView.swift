
//
//  MLHybridWebView.swift
//  Pods
//

import UIKit
import WebKit

open class MLHybridContentView: WKWebView {

    public var htmlString: String?
    
    //MARK:系统方法
    public convenience init(frame: CGRect) {
        //初始化和设置cookie
        let userContentController:WKUserContentController = WKUserContentController()
        let cookieValue = "document.cookie ='platform=\(MLHybrid.shared.platform);path=/;expires=Sat, 02 May 2020 23:38:25 GMT;';document.cookie = 'sess=\(MLHybrid.shared.sess);path=/;expires=Sat, 02 May 2020 23:38:25 GMT;';"
        let cookieScript:WKUserScript = WKUserScript.init(source: cookieValue, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        userContentController.addUserScript(cookieScript)
        let webViewConfig:WKWebViewConfiguration = WKWebViewConfiguration()
        webViewConfig.userContentController = userContentController
        
        self.init(frame: frame, configuration: webViewConfig)
    }
    
    private override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame:frame,configuration:configuration)
        self.initUI()
        //UserAgent这里设置不成功
        //configUserAgent()
        //Cookie这里设置不成功
        //customerCookie()
        NotificationCenter.default.addObserver(forName: MLHybridNotification.updateCookie, object: nil, queue: nil) { [weak self] (notification) in
            self?.customerCookie()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    //MARK:自定义方法
    func initUI () {
        self.backgroundColor = UIColor.white
        self.scrollView.bounces = false
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    //设置userAgent
    func configUserAgent () {
        //wkwebview
        self.evaluateJavaScript("navigator.userAgent") { (result, error) in
            var newUserAgentStr:String = ""
            guard let userAgentStr:String = result as? String else { return }
            guard userAgentStr.range(of: MLHybrid.shared.userAgent) == nil else { return }
            guard let versionStr = Bundle.main.infoDictionary?["CFBundleShortVersionString"] else {return}
            newUserAgentStr.append(userAgentStr)
            newUserAgentStr.append(" \(MLHybrid.shared.userAgent)\(versionStr) ")
            UserDefaults.standard.register(defaults: ["UserAgent" : newUserAgentStr])
        }
        
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
    
    //获取控制器
    func vcOfView(view: UIView) -> MLHybridViewController {
        var nextResponder = view.next
        while !(nextResponder is MLHybridViewController) {
            nextResponder = nextResponder?.next ?? UIViewController()
        }
        return nextResponder as? MLHybridViewController ?? MLHybridViewController()
    }
    
}

