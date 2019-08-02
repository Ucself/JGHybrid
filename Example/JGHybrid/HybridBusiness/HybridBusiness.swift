//
//  HybridBusiness.swift
//  DoctorHealth
//
//  Created by 李保君 on 2017/12/22.
//  Copyright © 2017年 doctorworker. All rights reserved.
//

//import UIKit
//import JGHybrid
//
//extension HybridBusiness {
//    
//    //单例
//    static let `default`:HybridBusiness = HybridBusiness()
//    
//    //MARK: -- 内部方法 --
//    
//    /// Hybrid回调
//    ///
//    /// - Parameters:
//    ///   - command: 命令对象
//    ///   - params: 回调数据
//    ///   - err_no: 回调码
//    ///   - msg: 回调信息
//    func handleCallback(_ command: HybridCommand,
//                        _ params: Any = ["isSuccess" : true],
//                        err_no: Int = 0,
//                        msg: String = "succuess") {
//        //执行H5的回调
//        command.callBack(data: params,
//                         err_no: err_no,
//                         msg: msg,
//                         callback: command.callbackId) { (msg) in }
//    }
//    
//    //MARK: -基础接口-
//    
//    /// 接口执行检测
//    ///
//    /// - Parameter command: command对象
//    @objc func checkJsApi(_ command: HybridCommand) {
//        self.handleCallback(command, [])
//    }
//    
//    /// 动态读取当前类的所有方法
//    ///
//    /// - Parameter command: command对象
//    @objc func getAllApi(_ command: HybridCommand) {
//        var methodCount:UInt32 = 0
//        var result = [String]()
//        guard let methodList = class_copyMethodList(HybridBusiness.self, &methodCount) else { return }
//        //打印方法
//        for i in 0..<Int(methodCount) {
//            if let method = methodList[i] as? Method {
//                result.append(String(_sel:method_getName(method)))
//            }
//        }
//        free(methodList)
//        result = result.filter{$0 != "init"}
//        result = result.filter{$0 != ".cxx_destruct"}
//        self.handleCallback(command,result)
//    }
//    
//    /// 获取本地文档对外暴露的接口
//    ///
//    /// - Parameter command: command对象
//    @objc func getApiDoc(_ command: HybridCommand) {
//        let jsonPath = Bundle.main.path(forResource: "sdk", ofType: "json")
//        
//        if let data = NSData.init(contentsOfFile: jsonPath!) {
//            do {
//                let jsonData = try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers)
//                self.handleCallback(command, jsonData)
//            } catch let error as Error? {
//                print("读取文档出现错误!",error)
//            }
//        } else {
//            print("未读取到文档")
//        }
//    }
//}
