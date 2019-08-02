//
//  HybridViewController+Extension.swift
//  JGHybrid
//
//  Created by 李保君 on 2018/3/16.
//

import UIKit
import WebKit

private let NAVBAR_COLORCHANGE_POINT:CGFloat = 80

extension HybridViewController {
    
    //MARK: 自定义方法
    func initUI() {
        //加载等待开始
        if self.needStartWait {
            Hybrid.shared.delegate?.startWait()
        }
        self.hidesBottomBarWhenPushed = needHidesBottomBar
        self.setUpBackButton()
        //设置布局到顶部self.view
        self.extendedLayoutIncludesOpaqueBars = true
        //设置样式
        self.jg_navBarBarTintColor = self.barTintColor
        self.jg_navBarTitleColor = self.titleColor
        if self.needFullScreen {
            self.jg_navBarBackgroundAlpha = 0.0
        }
        else {
            self.jg_navBarBackgroundAlpha = HybridConfiguration.default.navigationBarBackgroundAlpha
        }
    }
    
    func initContentView() {
        //容器数据对象
        self.contentView = HybridContentView()
        //不需要自动边距
        if #available(iOS 11.0, *) {
            self.contentView.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.view.addSubview(self.contentView)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        //容器布局
        var topConstraint:NSLayoutConstraint!
        if #available(iOS 11.0, *) {
            topConstraint = NSLayoutConstraint(item: self.contentView!, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1.0, constant: 0)
        }
        else {
            topConstraint = NSLayoutConstraint(item: self.contentView!, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 0)
        }
//        topConstraint = NSLayoutConstraint(item: self.contentView!, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 0)
        if self.needFullScreen {
            //全屏的话约束到view
            topConstraint = NSLayoutConstraint(item: self.contentView!, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0)
        }
        let leftConstraint = NSLayoutConstraint(item: self.contentView!, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: self.contentView!, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: self.contentView!, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        self.view.addConstraints([leftConstraint,rightConstraint,topConstraint,bottomConstraint])
        //设置代理
        self.contentView.uiDelegate = self
        self.contentView.navigationDelegate = self
        self.contentView.scrollView.delegate = self
        if #available(iOS 9.0, *) {
            self.contentView.customUserAgent = defaultUserAgent
        }
        
        //js 注入 requestHybrid
        self.contentView.configuration.userContentController.add(self, name: "requestHybrid")
        //监听键盘弹起与隐藏
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func initProgressView() {
        self.progressView = UIProgressView.init(progressViewStyle: .default)
        self.progressView.progressTintColor = UIColor.init(red: 235/255.0, green: 97/255.0, blue: 83/255.0, alpha: 1)
        self.progressView.trackTintColor = UIColor.clear
        self.progressView.frame = CGRect.init(x: self.contentView.frame.origin.x, y: self.contentView.frame.origin.y, width: self.view.frame.size.width, height: 3)
        //添加进度条
        if self.needLoadProgress {
            self.view.addSubview(self.progressView)
            self.progressView.translatesAutoresizingMaskIntoConstraints = false
            let leftConstraint = NSLayoutConstraint(item: self.progressView!, attribute: .left, relatedBy: .equal, toItem: self.contentView, attribute: .left, multiplier: 1.0, constant: 0)
            var topConstraint: NSLayoutConstraint
            if #available(iOS 11.0, *) {
                topConstraint = NSLayoutConstraint(item: self.progressView!, attribute: .top, relatedBy: .equal, toItem: self.contentView.safeAreaLayoutGuide, attribute: .top, multiplier: 1.0, constant: 0)
            } else {
                topConstraint = NSLayoutConstraint(item: self.progressView!, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1.0, constant: 0)
            }
            let widthConstraint = NSLayoutConstraint(item: self.progressView!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: self.view.frame.size.width)
            let heightConstraint = NSLayoutConstraint(item: self.progressView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 3)
            self.view.addConstraints([leftConstraint,topConstraint,widthConstraint,heightConstraint])
        }
    }
    
    //初始化控件数据
    func initData(){
        //设置userAgent
        if HybridConfiguration.default.userAgent == defaultUserAgent {
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
            userAgentStr.append(" JGHybrid/\(versionStr) ")
            HybridConfiguration.default.userAgent = userAgentStr
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
        //加载本地
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
        let image = UIImage(named: HybridConfiguration.default.backIndicator)
        button.setImage(image, for: .normal)
        button.contentHorizontalAlignment = .left
        let item = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = item
    }
    
    @objc func backButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func keyBoardShow(){
        let point:CGPoint = self.contentView.scrollView.contentOffset
        self.keyBoardPoint = point
    }
    
    @objc func keyBoardHidden(){
        self.contentView.scrollView.contentOffset = self.keyBoardPoint
    }
    

    //重新加载WKWebview
    public func reloadContentView(){
        guard urlPath != nil else {return}
        let urlRequest:URLRequest = URLRequest.init(url: urlPath!)
        //urlRequest.setValue(MLHybridConfiguration.default.cookieString, forHTTPHeaderField: MLHybridConfiguration.default.cookieName)
        self.contentView.load(urlRequest)
    }
    
}

extension HybridViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        if (offsetY > NAVBAR_COLORCHANGE_POINT) {
            changeNavBarAnimateWithIsClear(isClear: false)
        } else {
            changeNavBarAnimateWithIsClear(isClear: true)
        }
    
    }
    
    // private
    private func changeNavBarAnimateWithIsClear(isClear:Bool)
    {
        UIView.animate(withDuration: 0.8, animations: { [weak self] in
            if let weakSelf = self
            {
                if (isClear == true) {
//                    weakSelf.navBarBackgroundAlpha = 0
                }
                else {
//                    weakSelf.navBarBackgroundAlpha = 1.0
                }
            }
        })
    }
}
