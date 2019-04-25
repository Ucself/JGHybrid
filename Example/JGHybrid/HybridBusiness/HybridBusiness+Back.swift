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
    //MARK: -`back协议`-
    
    /// back
    ///
    /// - Parameter command: command
    @objc func back(command: HybridCommand) {
        let params:HybridBackParams = HybridBackParams.convert(command.params)
        command.args = params
        guard let navigationVC = command.viewController?.navigationController else {
            command.viewController?.dismiss(animated: true, completion: nil)
            //回调
            self.handleCallback(command, ["isSuccess" : false])
            return
        }
        //-1代表跳入根目录
        if params.step == -1 {
            navigationVC.popToRootViewController(animated: true)
            //回调
            self.handleCallback(command)
            return
        }
        //返回指定步骤
        if let vcs = command.viewController?.navigationController?.viewControllers {
            if vcs.count > params.step {
                let vc = vcs[vcs.count - params.step - 1]
                let _ = command.viewController?.navigationController?.popToViewController(vc, animated: true)
                //回调
                self.handleCallback(command)
                return
            }
        }
    }
}
