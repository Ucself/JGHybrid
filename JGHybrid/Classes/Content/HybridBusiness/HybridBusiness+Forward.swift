//
//  InitBusiness.swift
//  DoctorHealth
//
//  Created by 李保君 on 2018/12/26.
//  Copyright © 2018 doctorworker. All rights reserved.
//

import Foundation

extension HybridBusiness {
    //MARK: -`forward跳转协议`-
    /// forward跳转
    ///
    /// - Parameter command: command命令
    @objc open func forward(command: HybridCommand) {
        let params:HybridForwardParams = HybridForwardParams.convert(command.params)
        command.args = params
        if params.type == "h5" {
            guard let webViewController = Hybrid.load(urlString: params.url) else {return}
            guard let navi = command.viewController?.navigationController else {return}
            webViewController.titleName = params.title
            //标题颜色
            if UIColor.hybridColorWithHex(params.color) != .clear {
                webViewController.titleColor = UIColor.hybridColorWithHex(params.color)
                
            }
            //标题背景
            if UIColor.hybridColorWithHex(params.background) != .clear {
                webViewController.barTintColor = UIColor.hybridColorWithHex(params.background)
            }
            //如果是全屏，则为透明色
            if params.fullscreen {
                webViewController.needFullScreen = params.fullscreen
            }
            
            navi.pushViewController(webViewController, animated: params.animate)
            //回调
            command.callBack(data: [:],
                             err_no: 0,
                             msg: "succuess",
                             callback: command.callbackId) { (msg) in }
        } else {
            //native跳转交给外部处理
            command.name = "forwardNative"
            self.forwardNative(command: command)
        }
    }
    /// h5 forward跳转Native页面
    ///
    /// - Parameter command: command
    @objc open func forwardNative(command: HybridCommand){
        
        
    }
}
