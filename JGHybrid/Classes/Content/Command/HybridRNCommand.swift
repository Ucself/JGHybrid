//
//  HybridRNCommand.swift
//  JGHybrid
//
//  Created by 李保君 on 2018/11/29.
//

import UIKit

open class HybridRNCommand: NSObject {

    //指令名
    public var name:String = ""
    //外部使用参数
    public var params: [String: AnyObject] = [:]
    //内部使用参数
    public var args: HybirdCommandParams = HybirdCommandParams()
    //执行后回调
    public var callback:((_ response:[Any]) -> Void)?
    
    
    /// 解析命令消息成RN对象
    ///
    /// - Parameters:
    ///   - dictionary: 字典
    ///   - callback: 回调 ，逃逸闭包，调试注意，可能回调的时候对象已经释放
    /// - Returns: 返回对象
    class func parseDictionary(_ dictionary: [String: AnyObject],callback:@escaping ((_ response:[Any]) -> Void)) -> HybridRNCommand? {
        
        guard let name = dictionary["name"] as? String, let params = dictionary["params"] as? [String:AnyObject] else {
            return nil
        }
        let command:HybridRNCommand = HybridRNCommand()
        command.name = name
        command.params = params
        command.args = HybirdCommandParams.convert(params, nameType: HybridMethodType(rawValue:name))
        command.callback = callback
        
        return command
    }
}
