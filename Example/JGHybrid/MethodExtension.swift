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
    func startWait() {
        
    }
    
    func stopWait() {
        
    }
    
    func commandExtension(command: MLHybirdCommand) {
        print("自定义响应Hybrid命令 ===> \(command.name)")
    }

}
