//
//  MLHybridMethodProtocol.swift
//  JGHybrid
//
//  Created by 李保君 on 2017/12/11.
//

import UIKit

open class MLHybridMethod {}

/// 命令扩展协议
public protocol MLHybridMethodProtocol {
    
    /// 和业务有关的命令扩展
    ///
    /// - Parameter command: 命令对象
    func commandExtension(command: MLHybirdCommand)
}
