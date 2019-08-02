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
    //MARK: -`Pagehide callbackId协议`-
    
    
    /// 设置页面隐藏回调callbackId
    ///
    /// - Parameter command: command
    @objc func pagehide(command: HybridCommand) {
        command.viewController?.onHideCallBack = command.callbackId
        //回调
//        self.handleCallback(command)
    }

}
