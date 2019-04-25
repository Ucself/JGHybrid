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
    //MARK: -`hybridInit协议`-
    
    /// 初始化配置，配置H5回调函数
    ///
    /// - Parameter command: command命令
    @objc func hybridInit(command: HybridCommand) {
        let args:HybridInitParams = HybridInitParams.convert(command.params)
        command.args = args
        command.viewController?.hybridEvent = args.callback_name
        self.handleCallback(command)
    }
}
