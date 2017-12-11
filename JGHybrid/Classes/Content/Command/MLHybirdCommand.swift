//
//  MLHybirdCommand.swift
//  Pods
//

import Foundation
import WebKit

open class MLHybirdCommand {
    
    //指令名
    public var name:String = ""
    //外部使用参数
    public var params: [String: AnyObject] = [:]
    //内部使用参数
    public var args: MLHybirdCommandParams = MLHybirdCommandParams()
    //回调Id
    public var callbackId: String = ""
    //发出指令的控制器
    public weak var viewController: MLHybridViewController!
    //
    public weak var webView: WKWebView! = WKWebView()

    /// 解析并执行hybrid指令
    ///
    /// - Parameters:
    ///   - urlString: 原始指令串
    ///   - webView: 触发指令的容器
    ///   - appendParams: 附加到指令串中topage地址的参数 一般情况下不需要
    class func analysis(request: URLRequest, webView: WKWebView) -> MLHybirdCommand? {
        guard let url = request.url else  { return nil }
        if url.scheme != MLHybridConfiguration.default.scheme {
            return nil
        }
        let command = MLHybirdCommand()
        let result = command.contentResolver(url: url)
        command.name = result.function
        command.params = result.params
        command.args = result.args
        command.callbackId = result.callbackId
        command.webView = webView
        return command
    }
    
    /// 解析hybrid指令
    ///
    /// - Parameters:
    ///   - urlString: 原始指令串
    /// - Returns: 执行方法名、参数、回调ID
    private func contentResolver(url: URL) -> (function: String, params:[String: AnyObject], args: MLHybirdCommandParams, callbackId: String) {
        let functionName = url.host ?? ""
        let paramDic = url.hybridURLParamsDic()
        let argsDic = (paramDic["params"] ?? "").hybridDecodeURLString().hybridDecodeJsonStr()
        //let args = MLHybirdCommandParams.convert(argsDic)
        let callBackId = paramDic["callback"] ?? ""
        return (functionName, argsDic, args, callBackId)
    }
    
}
