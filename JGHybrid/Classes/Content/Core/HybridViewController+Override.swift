//
//  HybridViewController+.swift
//  JGHybrid
//
//  Created by 李保君 on 2018/6/28.
//

import UIKit

extension HybridViewController {
    //MARK: 系统重写方法
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.initContentView()
        self.initProgressView()
        self.initData()
        self.initRequest()
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
        self.commandExecute.command.webView.evaluateJavaScript(MLHybridConfiguration.default.vendorSub) { (_,_) in }
        
        //设置透明
        if self.isFullScreen {
            self.navigationController?.navigationBar.hybridSetBackgroundClear()
        }
        //临时要求的回调
        if self.pageFirstShow {
            self.pageFirstShow = false
        }
        else {
            self.commandExecute.command.webView.evaluateJavaScript(MLHybridConfiguration.default.pageShowEvent) { (_, _) in }
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
        
        //还原上一个控制器  项目中还是有问题 屏蔽
//        if self.upNavigationBarIsHide != nil {
//            self.navigationController?.setNavigationBarHidden(upNavigationBarIsHide!, animated: true)
//        }
//        if self.upNavigationBarBackgroundColor != nil {
//            self.navigationController?.navigationBar.hybridSetBackgroundColor(self.upNavigationBarBackgroundColor)
//        }
        
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
