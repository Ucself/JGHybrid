//
//  MLHybridMethodProtocol.swift
//  JGHybrid
//
//  Created by 李保君 on 2017/12/11.
//

import UIKit

//更换名 兼容老版本
public typealias MLHybridMethodProtocol = HybridMethodProtocol
/// 命令扩展协议
public protocol HybridMethodProtocol {
    
    /// 和业务有关的命令扩展
    ///
    /// - Parameter command: 命令对象
    func commandExtension(command: MLHybridCommand)
    
    /// 和业务有关的RN命令扩展
    ///
    /// - Parameter command: 命令对象
//    func commandRNExtension(rnCommand: HybridRNCommand) -> Any?
    
    /// 页面加载失败所需操作
    ///
    /// - Parameter command: 命令对象
    func didFailLoad(viewController: MLHybridViewController)
    
    /// 加载等待开始  业务需要重写
    func startWait()
    
    /// 加载等待结束  业务需要重写
    func stopWait()
}


