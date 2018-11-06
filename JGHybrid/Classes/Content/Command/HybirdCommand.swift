//
//  MLHybirdCommand.swift
//  Pods
//

import Foundation
import WebKit

//更换类名 兼容老版本
public typealias MLHybirdCommand = HybirdCommand

open class HybirdCommand {
    
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
    //webView
    public weak var webView: WKWebView! = WKWebView()
    
    //通过Dictionary转换,现在只g提供给RN用，未来做优化和拆分
    public static func convert(_ dic: [String: AnyObject]) -> HybirdCommand {
        let command = HybirdCommand()
        if let name: String = dic["name"] as? String {
            command.name = name
        }
        
        if let params = dic["params"] as? [String: AnyObject] {
            command.params = params
        }
        
        if let args = dic["args"] as? [String: AnyObject] {
            command.args = MLHybirdCommandParams.convert(args, nameType: nil)
        }
        
        if let callbackId = dic["callbackId"] as? String {
            command.callbackId = callbackId
        }
        
        return command
    }

    /// 执行回调
    ///
    /// - Parameters:
    ///   - data: 回调数据
    ///   - err_no: 错误码
    ///   - msg: 描述
    ///   - callback: js回调id
    ///   - completion: 回掉完成后回调
    public func callBack(data:Any = "", err_no: Int = 0, msg: String = "succuess", callback: String, completion: @escaping ((String) ->Void))  {
        let data = ["data": data,
                    "code": err_no,
                    "callback": callback,
                    "msg": msg] as [String : Any]
        
        let dataString = data.hybridJSONString()
        webView.evaluateJavaScript(self.viewController.hybridEvent + "(\(dataString));") { (result, error) in
            if let resultStr = result as? String {
                completion(resultStr)
            }else  if  let error = error{
                completion(error.localizedDescription)
            }
            else {
                completion("")
            }
        }
    }
    //MARK: - private
    
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
