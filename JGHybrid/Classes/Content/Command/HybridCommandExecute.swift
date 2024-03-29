//
//  HybridCommandExecute.swift
//  Pods
//

import UIKit
import CoreLocation
import WebKit

//更换类名 兼容老版本
public typealias MLHybridCommandExecute = HybridCommandExecute

public class HybridCommandExecute: NSObject {
    
    public var apiClassObj:NSObject?
    public var command: HybridCommand = HybridCommand()
    
    public override init() {
        super.init()
        guard let apiClass:NSObject.Type = self.swiftClassFromString(className: self.apiClassName()) as? NSObject.Type else {
            return
        }
        apiClassObj = apiClass.init()
    }
    
    //MARK: Method
    func performCommand(request: URLRequest, webView: WKWebView) -> Bool {
        if let hybridCommand = HybridCommand.analysis(request: request, webView: webView) {
            print("---------------command start-----------------")
            print("👇URL:\n\((request.url?.absoluteString ?? "")!)")
            command = hybridCommand
            execute()
            return true
        } else {
            return false
        }
    }
    //通过命令执行
    func performCommand(command:HybridCommand) -> Bool {
        print("---------------command start-----------------")
        print("👇JS METHOD:\nhybrid.requestHybrid()")
        self.command = command
        execute()
        return true
    }
    
    func apiClassName() -> String {
        return HybridConfiguration.default.apiClassName
    }
    
    private func swiftClassFromString(className: String) -> AnyObject.Type? {
//        let clsName = Bundle.main.infoDictionary!["CFBundleName"] as! String + "." + className
        let clsName = "JGHybrid." + className
        return NSClassFromString(clsName)
    }
    
    /// 根据指令执行对应的方法
    private func execute() {
        //打印指令
        print("👇NAME:\n\(self.command.name)")
        print("👇PARAMS:\n\(self.command.params)")
        print("---------------command end-------------------")
        //打印H5日志到控制台
        command.webView?.evaluateJavaScript("console.log({'name':'\(self.command.name)','params':\(command.params.hybridJSONString()),'callback':'\(self.command.callbackId)'})") { (result, error) in }

        guard let hybridObj = self.apiClassObj else { return }
        let selector = NSSelectorFromString(self.command.name)
        let selectorWithParams = NSSelectorFromString("\(self.command.name):")
        let selectorWithCommand = NSSelectorFromString("\(self.command.name)WithCommand:")
        if hybridObj.responds(to: selector) {
            hybridObj.perform(selector)
        } else if hybridObj.responds(to: selectorWithParams) {
            hybridObj.perform(selectorWithParams, with: self.command, afterDelay: 0)
        } else if hybridObj.responds(to: selectorWithCommand) {
            hybridObj.perform(selectorWithCommand, with: self.command, afterDelay: 0)
        } else {
            print("ERROR: Method \(String(describing: self.command.name)) not defined")
        }
    }
}

