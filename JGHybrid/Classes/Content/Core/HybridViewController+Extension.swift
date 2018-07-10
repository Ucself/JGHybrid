//
//  HybridViewController+Extension.swift
//  JGHybrid
//
//  Created by 李保君 on 2018/3/16.
//

import UIKit
import WebKit

extension HybridViewController {

    //MARK: 自定义方法
    func initUI() {
        //加载等待开始
        MLHybrid.shared.delegate?.startWait()
        self.hidesBottomBarWhenPushed = needHidesBottomBar
        self.setUpBackButton()
        //设置布局到顶部self.view
        self.extendedLayoutIncludesOpaqueBars = true
        
        //获取上一个控制器的数据
        self.upNavigationBarIsHide = self.navigationController?.isNavigationBarHidden
        self.upNavigationBarBackgroundColor = self.navigationController?.navigationBar.backgroundColor
    }
    
    func initContentView() {
        //设置大标题
        if !self.needLargeTitle {
            //设置约束高度
            self.largeTitleViewHeight = 0
            self.navigationItem.title = self.titleName
        }
        else {
            self.largeTitleViewHeight = 74.5
            self.navigationItem.title = ""
        }
        //容器数据对象
        self.contentView = MLHybridContentView()
        //不需要自动边距
        if #available(iOS 11.0, *) {
            self.contentView.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
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
        //        let bottomGuide = self.bottomLayoutGuide
        //大标题Label布局
        let leftTitleLabelConstraint = NSLayoutConstraint(item: self.largeTitleLabel!, attribute: .left, relatedBy: .equal, toItem: self.largeTitleView, attribute: .left, multiplier: 1.0, constant: 22)
        let rightTitleLabelConstraint = NSLayoutConstraint(item: self.largeTitleLabel!, attribute: .right, relatedBy: .equal, toItem: self.largeTitleView, attribute: .right, multiplier: 1.0, constant: 0)
        let topTitleLabelConstraint = NSLayoutConstraint(item: self.largeTitleLabel!, attribute: .top, relatedBy: .equal, toItem: self.largeTitleView, attribute: .top, multiplier: 1.0, constant: 0)
        let bottomTitleLabelConstraintt = NSLayoutConstraint(item: self.largeTitleLabel!, attribute: .bottom, relatedBy: .equal, toItem: self.largeTitleView, attribute: .bottom, multiplier: 1.0, constant: 0)
        //大标题布局
        let leftLargeTitleConstraint = NSLayoutConstraint(item: self.largeTitleView!, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0)
        let rightLargeTitleConstraint = NSLayoutConstraint(item: self.largeTitleView!, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0)
        var topLargeTitleConstraint:NSLayoutConstraint! = NSLayoutConstraint(item: self.largeTitleView!, attribute: .top, relatedBy: .equal, toItem: topGuide, attribute: .bottom, multiplier: 1.0, constant: 0)
        if isFullScreen {
            //全屏的话约束到view
            topLargeTitleConstraint = NSLayoutConstraint(item: self.largeTitleView!, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0)
        }
        self.largeTitleViewTop = topLargeTitleConstraint
        let heightLargeTitleConstrain = NSLayoutConstraint(item: self.largeTitleView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.largeTitleViewHeight)
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
        if #available(iOS 9.0, *) {
            self.contentView.customUserAgent = defaultUserAgent
        }
        
        //js 注入 requestHybrid
        self.contentView.configuration.userContentController.add(self, name: "requestHybrid")
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
        if MLHybridConfiguration.default.userAgent == defaultUserAgent {
            return
        }
        let webView = WKWebView.init(frame: CGRect.zero)
        self.view.addSubview(webView)
        webView.evaluateJavaScript("navigator.userAgent") { [weak self](result, error) in
            //获取userAgent数据
            guard let weakSelf = self,var userAgentStr:String = result as? String else { return }
            //查看是否设置过
            guard MLHybridConfiguration.default.userAgent == "" else {
                webView.removeFromSuperview()
                return
            }
            //未获取到版本
            guard let versionStr = Bundle.main.infoDictionary?["CFBundleShortVersionString"] else {return}
            userAgentStr.append(" doc_hybrid_heath_\(versionStr) ")
            userAgentStr.append(" Hybrid/\(versionStr) ")
            MLHybridConfiguration.default.userAgent = userAgentStr
            if #available(iOS 9.0, *) {
                weakSelf.contentView.customUserAgent = userAgentStr
            } else {
                // Fallback on earlier versions
                UserDefaults.standard.register(defaults: ["UserAgent" : userAgentStr])
            }
            webView.removeFromSuperview()
        }
    }
    //加载数据
    func initRequest() {
        //加载
        guard let loadUrl = urlPath else { return }
        //urlRequest.setValue(MLHybridConfiguration.default.cookieString, forHTTPHeaderField: MLHybridConfiguration.default.cookieName)
        let urlString = loadUrl.absoluteString
        
        if HybridConfiguration.default.cacheMap.count > 0 && HybridConfiguration.default.isCacheHtml{
            for url in HybridConfiguration.default.cacheMap {
                if urlString.contains(url) {
                    let path = NSHomeDirectory() + "/Documents/HybridOfflinePackage\(url)/index.html"
                    
                    do {
                        let htmlData = try NSData(contentsOfFile: path, options: NSData.ReadingOptions.uncached)
                        if let htmlString = String(data: htmlData as Data, encoding: .utf8) {
                            contentView.loadHTMLString(htmlString, baseURL: loadUrl)
                            return
                        }
                    } catch {
                        
                    }
                }
            }
        }
        
        let urlRequest:URLRequest = URLRequest.init(url: loadUrl)
        self.contentView.load(urlRequest)
    }
    
    //MARK: ------
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
    
    //重新加载WKWebview
    public func reloadContentView(){
        guard urlPath != nil else {return}
        let urlRequest:URLRequest = URLRequest.init(url: urlPath!)
        //urlRequest.setValue(MLHybridConfiguration.default.cookieString, forHTTPHeaderField: MLHybridConfiguration.default.cookieName)
        self.contentView.load(urlRequest)
    }

}
