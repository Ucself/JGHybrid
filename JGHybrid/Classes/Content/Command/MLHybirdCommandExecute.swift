//
//  MLHybirdCommandExecute.swift
//  Pods
//

import UIKit
import CoreLocation
import WebKit

class MLHybirdCommandExecute: NSObject {
    
    var command: MLHybirdCommand = MLHybirdCommand()
    
    //MARK: Method
    func performCommand(request: URLRequest, webView: WKWebView) -> Bool {
        if let hybridCommand = MLHybirdCommand.analysis(request: request, webView: webView) {
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
    func performCommand(command:MLHybirdCommand) -> Bool {
        print("---------------command start-----------------")
        print("👇JS METHOD:\nhybrid.requestHybrid()")
        self.command = command
        execute()
        return true
    }
    
    /// 根据指令执行对应的方法
    private func execute() {
        //打印指令
        print("👇NAME:\n\(self.command.name)")
        print("👇PARAMS:\n\(self.command.params)")
        print("---------------command end-------------------")
        
        guard let funType = MLHybridMethodType(rawValue: command.name) else {
            MLHybrid.shared.delegate?.commandExtension(command: command)
            return
        }
        switch funType {
        //新命令
        case .hybridInit:
            self.hybridInit()
        case .hybridForward:
            self.hybridForward()
        case .hybridModal:
            self.hybridModal()
        case .hybridDismiss:
            self.hybridDismiss()
        case .hybridBack:
            self.hybridBack()
        case .hybridHeader:
            self.hybridHeader()
        case .hybridScroll:
            self.hybridScroll()
        case .hybridPageshow:
            self.hybridPageshow()
        case .hybridPagehide:
            self.hybridPagehide()
        case .hybridDevice:
            self.hybridDevice()
        case .hybridLocation:
            self.hybridLocation()
        case .hybridClipboard:
            self.hybridClipboard()
        default:
            break
        }
    }
}

