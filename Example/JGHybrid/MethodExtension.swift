//
//  MethodExtension.swift
//  MLHybrid
//
//  Created by yang cai on 2017/8/23.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import Foundation
import JGHybrid

class MethodExtension: MLHybridMethodProtocol {
    
    func commandRNExtension(rnCommand: HybridRNCommand) -> Any? {
        return nil
    }
    
    func didFailLoad(command: MLHybirdCommand) { }
    
    func startWait() { }
    
    func stopWait() { }
 
    //页面加载失败所需操作
    func didFailLoad(viewController: MLHybridViewController) {
        let failView:LoadFailedView = LoadFailedView.initWithXib()
        viewController.view.addSubview(failView)
        failView.frame = viewController.view.frame
    }
    
    func commandExtension(command: MLHybirdCommand) {
        switch command.name {
        case "Business":
            break
        default:
            break
        }
        
    }

}
