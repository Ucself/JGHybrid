//
//  HybridViewController+WKScriptMessageHandler.swift
//  JGHybrid
//
//  Created by 李保君 on 2018/3/16.
//

import UIKit
import WebKit

//MARK:WKScriptMessageHandler
extension MLHybridViewController:WKScriptMessageHandler {
    //MessageHandler 回调
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        //判断是否是requestHybrid 命令
        guard message.name == "requestHybrid"  else {  return }
        //判断是否符合参数
        guard let commandDic:Dictionary<String,Any> = message.body as? Dictionary<String,Any> else { return }
        
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
        command.webView = self.contentView
        command.viewController = self
        commandExecute.command = command
        _ = commandExecute.performCommand(command: command)
    }
}
