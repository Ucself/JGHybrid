
//
//  MLHybridWebView.swift
//  Pods
//

import UIKit
import WebKit

open class MLHybridContentView: WKWebView {
    
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
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK:自定义方法
    func initUI () {
        self.scrollView.backgroundColor = UIColor.init(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)
        self.scrollView.bounces = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

