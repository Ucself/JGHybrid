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
    
    //MARK: -`storage数据存储协议`-
    
    /// storage数据存储
    ///
    /// - Parameter command: command
    @objc func storage(command: HybridCommand) {
        
        let params:HybridStorageParams = HybridStorageParams.convert(command.params)
        command.args = params
        
        //Storage类型
        let action:String = params.action
        //userdefault key
        let userDefaultKey:String = "HybridStorageUserDefaultKey"
        switch action {
        case "set":
            //首先拿出现有的存储
            var newHashDic:[String:String] = [:]
            if let hashDic:[String:String] = UserDefaults.standard.object(forKey: userDefaultKey) as? [String:String] {
                newHashDic = hashDic
                //累加新值
                for (key,value) in params.hashDic {
                    newHashDic[key] = value
                }
            }
            else {
                newHashDic = params.hashDic
            }
            //设置存储
            if newHashDic.count > 0 {
                UserDefaults.standard.set(newHashDic, forKey: userDefaultKey)
                //回调
//                self.handleCallback(command, ["isSuccess":true])
            }
            else{
                //回调
//                self.handleCallback(command, ["isSuccess":false])
            }
        case "get":
            //获取存储
            if let hashDic:[String:String] = UserDefaults.standard.object(forKey: userDefaultKey) as? [String:String] {
                //回调
//                self.handleCallback(command, hashDic)
            }
            else {
                //回调
//                self.handleCallback(command, [], err_no: -1, msg: "No data stored")
            }
            
        case "remove":
            UserDefaults.standard.removeObject(forKey: userDefaultKey)
//            self.handleCallback(command)
        default:
            break
        }
    }
}
