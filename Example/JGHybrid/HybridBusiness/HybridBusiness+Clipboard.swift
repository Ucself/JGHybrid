//
//  InitBusiness.swift
//  DoctorHealth
//
//  Created by 李保君 on 2018/12/26.
//  Copyright © 2018 doctorworker. All rights reserved.
//

import Foundation
import JGHybrid

extension HybridBusiness {
    
    //MARK: -`设置剪切板数据协议`-
    
    /// 设置剪切板数据
    ///
    /// - Parameter command: command
    @objc func clipboard(command: HybridCommand) {
        let params:HybridClipboardParams = HybridClipboardParams.convert(command.params)
        command.args = params
        UIPasteboard.general.string = params.content
        self.handleCallback(command)
    }
    
}
