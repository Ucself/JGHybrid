//
//  HybridViewController+WKDelegate.swift
//  JGHybrid
//
//  Created by 李保君 on 2018/3/16.
//

import UIKit
import WebKit

//MARK: WKUIDelegate WKNavigationDelegate
extension MLHybridViewController: WKUIDelegate,WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if self.commandExecute.performCommand(request: navigationAction.request, webView: webView) {
            decisionHandler(.cancel)
        } else  {
            //h5打电话
            if let url:NSURL = navigationAction.request.url as NSURL?,
                let resourceSpecifier:String = url.resourceSpecifier ,
                let scheme:String = url.scheme ,
                scheme == "tel" {
                //打电话字符串
                let callPhone:String = "telprompt://\(resourceSpecifier)"
                DispatchQueue.main.async {
                    UIApplication.shared.openURL(URL.init(string: callPhone)!)
                }
            }
            
            decisionHandler(.allow)
        }
    }
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        if  let response = navigationResponse.response as? HTTPURLResponse, response.statusCode == 500 {
            //显示错误页面
            MLHybrid.shared.delegate?.didFailLoad(viewController: self)
            //加载关闭
            MLHybrid.shared.delegate?.stopWait()
        }
        decisionHandler(.allow)
    }
    
    public func webViewWebContentProcessDidTerminate(_ webView: WKWebView){
        webView.reload()
    }
    //页面加载失败
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("页面加载失败----\(error)")
        //无法连接服务器显示错误页面    -1002 不支持的URL
        if let ocError:NSError = error as NSError?, ocError.code != -1002 {
            MLHybrid.shared.delegate?.didFailLoad(viewController: self)
        }
        //加载失败
        MLHybrid.shared.delegate?.stopWait()
    }
    
    //页面跳转失败
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("页面跳转失败----\(error)")
        //加载失败
        MLHybrid.shared.delegate?.stopWait()
    }
    
    
}
