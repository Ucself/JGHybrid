//
//  HybridRNCommandExecute.swift
//  JGHybrid
//
//  Created by 李保君 on 2018/11/29.
//

import UIKit

class HybridRNCommandExecute: NSObject {

    var command: HybridRNCommand = HybridRNCommand()
    //通过命令执行
    func performCommand(command:HybridRNCommand) -> Any? {
        print("---------------command start-----------------")
        print("👇RN METHOD:\nhybrid.loadRN()")
        self.command = command
        return execute()
    }
    
    /// 根据指令执行对应的方法
    private func execute() -> Any? {
        //打印指令
        print("👇NAME:\n\(self.command.name)")
        print("👇PARAMS:\n\(self.command.params)")
        print("---------------command end-------------------")
        //和业务相关的协议
        guard let funType = MLHybridMethodType(rawValue: command.name) else {
            return MLHybrid.shared.delegate?.commandRNExtension(rnCommand: command)
        }
        var executeResult:Any?
        switch funType {
        //新命令
        case .hybridInit:
            executeResult  = self.hybridInit()
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
        case .hybridStorage:
            self.hybridStorage()
        default:
            break
        }
        return executeResult
    }
    
}
