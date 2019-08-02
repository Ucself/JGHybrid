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
    //MARK: -`modal跳转协议`-
    
    /// forward跳转
    ///
    /// - Parameter command: command命令
    @objc func modal(command: HybridCommand) {
        let params:HybridForwardParams = HybridForwardParams.convert(command.params)
        command.args = params
        if params.type == "h5" {
            guard let webViewController = MLHybrid.load(urlString: params.url) else {return}
            webViewController.title = params.title
            //是否全屏
            if params.fullscreen {
                webViewController.needFullScreen = params.fullscreen
            }
            command.viewController?.present(webViewController, animated: params.animate, completion: nil)
            //回调
            self.handleCallback(command)
        } else {
            //native跳转交给外部处理
            command.name = "modalNative"
            self.modal(command: command)
        }
    }
    
    /// h5 modal跳转Native页面
    ///
    /// - Parameter command: command
    @objc private func modalNative(command: MLHybridCommand){
        //回调
        self.handleCallback(command)
    }
}
