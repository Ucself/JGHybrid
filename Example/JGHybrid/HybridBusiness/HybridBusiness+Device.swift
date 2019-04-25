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
    
    //MARK: -`设备信息协议`-
    
    /// 获取设备信息
    ///
    /// - Parameter command: command
    @objc func device(command: HybridCommand) {
        let deviceInfor:[String:String] = ["version":"",
                                           "os":UIDevice.current.systemName,
                                           "dist":"app store",
                                           "uuid":UUID.init().uuidString]
        self.handleCallback(command, deviceInfor)
    }
}
