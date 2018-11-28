
//
//  MLHybridWebView.swift
//  Pods
//

import UIKit
import WebKit

//更换类名 兼容老版本
public typealias MLHybridContentView = HybridContentView

open class HybridContentView: WKWebView {
    
    //MARK:系统方法
    public convenience init(frame: CGRect) {
        //初始化和设置cookie
        let userContentController:WKUserContentController = WKUserContentController()
//        let cookieValue = ""
//        let cookieScript:WKUserScript = WKUserScript.init(source: cookieValue, injectionTime: .atDocumentStart, forMainFrameOnly: false)
//        userContentController.addUserScript(cookieScript)
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
        self.scrollView.backgroundColor = UIColor.hybridColorWithHex("FAFAFA")
        self.scrollView.bounces = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

