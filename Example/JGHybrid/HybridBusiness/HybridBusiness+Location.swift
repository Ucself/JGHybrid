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
    
    //MARK: -`获取定位信息协议`-
    
    /// 获取定位信息
    ///
    /// - Parameter command: command
    @objc func location(command: HybridCommand) {
        let params:HybridLocationParams = HybridLocationParams.convert(command.params)
        command.args = params
        let locationModel = MLHybridLocation()
        locationModel.getLocation { (success, errcode, resultData) in
            switch errcode {
            case 0:
                //定位成功
                _ = command.callBack(data: resultData as AnyObject? ?? "" as AnyObject, err_no: errcode, callback: params.located ,completion: {js in })
            case 1:
                //无权限
                _ = command.callBack(data: resultData as AnyObject? ?? "" as AnyObject, err_no: 2, callback: params.failed, completion: {js in })
            case 2:
                //定位失败
                _ = command.callBack(data: resultData as AnyObject? ?? "" as AnyObject, err_no: 1, callback: params.failed, completion: {js in })
            default:
                break
            }
        }
    }
    
}
