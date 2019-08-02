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
        //添加wkwebview监听
        self.contentView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
        //回调Hybrid
        if let callback = self.onShowCallBack {
            self.commandExecute.command.callBack(data: "", err_no: 0, msg: "onwebviewshow", callback: callback, completion: {js in })
        }
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //移除KVO
        self.contentView.removeObserver(self, forKeyPath: "estimatedProgress")
        //回调Hybrid
        if let callback = self.onHideCallBack {
            let _ =  self.commandExecute.command.callBack(data: "", err_no: 0, msg: "onwebviewshow", callback: callback, completion: {js in })
        }
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate;
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let observeObject:HybridContentView = object as? HybridContentView {
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
}
