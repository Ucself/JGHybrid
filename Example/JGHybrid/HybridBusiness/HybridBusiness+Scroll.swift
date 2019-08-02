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
    //MARK: -`Scroll回弹协议`-
    
    /// scrollView 回弹效果
    ///
    /// - Parameter command: command
    @objc func scroll(command: HybridCommand) {
        let params:HybridScrollParams = HybridScrollParams.convert(command.params)
        command.args = params
        command.webView?.scrollView.bounces = params.enable
        let backgroundColor:UIColor = UIColor.hybridColorWithHex(params.background)
        if backgroundColor != .clear {
            command.webView?.scrollView.backgroundColor = backgroundColor
        }
        //回调
//        self.handleCallback(command)
    }
}
