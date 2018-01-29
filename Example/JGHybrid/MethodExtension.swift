//
//  MethodExtension.swift
//  MLHybrid
//
//  Created by yang cai on 2017/8/23.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import Foundation
import JGHybrid

class MethodExtension: MLHybridMethodProtocol {
    func startWait() {
        
    }
    
    func stopWait() {
        
    }
    
    func commandExtension(command: MLHybirdCommand) {
        switch command.name {
        case "storage":
            //storage
            self.hybridStorage(command: command)
        default:
            break
        }
        
    }
    
    /// h5需要的数据长期保存
    ///
    /// - Parameter command: command
    func hybridStorage(command: MLHybirdCommand){
        //Storage类型
        guard let action:String = command.params["action"] as? String else { return }
        //userdefault key
        let userDefaultKey:String = "HybridStorageUserDefaultKey"
        switch action {
        case "set":
            //设置存储
            if let hashDic:[String:String] = command.params["hash"] as? [String:String] {
                UserDefaults.standard.set(hashDic, forKey: userDefaultKey)
            }
        case "get":
            //获取存储
            if let hashDic:[String:String] = UserDefaults.standard.object(forKey: userDefaultKey) as? [String:String] {
                command.callBack(data: hashDic,
                                 err_no: 0,
                                 msg: "",
                                 callback: command.callbackId, completion: { (msg) in })
            }
            else {
                command.callBack(data: [],
                                 err_no: -1,
                                 msg: "No data stored",
                                 callback: command.callbackId, completion: { (msg) in })
            }
            
        case "remove":
            UserDefaults.standard.removeObject(forKey: userDefaultKey)
        default:
            break
        }
        
    }

}
