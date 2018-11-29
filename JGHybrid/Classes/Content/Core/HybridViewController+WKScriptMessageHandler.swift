//
//  HybridViewController+WKScriptMessageHandler.swift
//  JGHybrid
//
//  Created by 李保君 on 2018/3/16.
//

import UIKit
import WebKit

//MARK:WKScriptMessageHandler
extension HybridViewController:WKScriptMessageHandler {
    //MessageHandler 回调
    open func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if let command:MLHybirdCommand = HybirdCommand.parseScriptMessage(message: message, viewController: self) {
            self.commandExecute.command = command
            _ = commandExecute.performCommand(command: command)
        }
        
    }
}
