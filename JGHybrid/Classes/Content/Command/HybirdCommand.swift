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
    
    //MARK: - 新版本解析URL为命令
    
    /// 解析命令消息成对象
    ///
    /// - Parameters:
    ///   - message: message回调对象
    ///   - viewController: 控制器
    /// - Returns: 返回命令对象
    public class func parseScriptMessage(message:WKScriptMessage, viewController:HybridViewController) -> MLHybirdCommand?{
        //判断是否是requestHybrid 命令
        guard message.name == "requestHybrid"  else { return  nil }
        //判断是否符合参数
        guard let commandDic:Dictionary<String,Any> = message.body as? Dictionary<String,Any> else { return nil }
        
        //Hybird命令对象
        let command:MLHybirdCommand = MLHybirdCommand()
        
        //判断是否有tagname
        if let name = commandDic["name"] as? String {
            command.name = name
        }
        if let params = commandDic["params"] as? [String: AnyObject] {
            command.params = params
            //转换为内部使用参数
            //let args = MLHybirdCommandParams.convert(params)   //旧的解析方式
            let args = MLHybirdCommandParams.convert(params, nameType: MLHybridMethodType(rawValue:command.name))
            command.args = args
        }
        if let callback = commandDic["callback"] as? String {
            command.callbackId = callback
        }
        command.webView = viewController.contentView
        command.viewController = viewController
        
        return command
    }
    
    //MARK: -
    
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
