//
//  PageshowBusiness.swift
//  DoctorHealth
//
//  Created by 李保君 on 2018/12/26.
//  Copyright © 2018 doctorworker. All rights reserved.
//

import Foundation

extension HybridBusiness {
    //MARK: -`Pageshow callbackId协议`-
    
    /// 设置页面显示回调callbackId
    ///
    /// - Parameter command: command
    @objc open func pageshow(command: HybridCommand) {
        command.viewController?.onShowCallBack = command.callbackId
        //回调
//        self.handleCallback(command)
    }

}
