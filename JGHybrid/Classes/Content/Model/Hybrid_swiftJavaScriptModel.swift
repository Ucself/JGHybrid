//
//  Hybrid_SwiftJavaScriptModel.swift
//  JGHybrid
//
//  Created by 李保君 on 2017/11/6.
//

import UIKit
import JavaScriptCore
import WebKit

class Hybrid_swiftJavaScriptModel:NSObject, SwiftJavaScriptDelegate {
    
    var jsContext:JSContext?
    weak var webView:WKWebView?
    //实现协议
    func requestHybrid(_ tagname:String?, _ param:[String:AnyObject]?) {
        //Hybird命令对象
        let command:MLHybirdCommand = MLHybirdCommand()
        //Hybird执行工具对象
        let tool: MLHybridTools = MLHybridTools()
        
        if tagname != nil {
            command.name = tagname!
        }
        if param != nil {
            command.params = param!
            //转换为内部使用参数
            let args = MLCommandArgs.convert(param!)
            command.args = args
        }
        command.webView = self.webView
        tool.command = command
        _ = tool.performCommand(command: command)
        
    }
}


// 定义协议SwiftJavaScriptDelegate 该协议必须遵守JSExport协议
@objc protocol SwiftJavaScriptDelegate: JSExport {
    
    /// js 调用Native命令
    ///
    /// - Parameters:
    ///   - tagname: 命令名称
    ///   - param: 命令参数对象
    func requestHybrid(_ tagname:String?, _ param:[String:AnyObject]?)
    
}
