//
//  MLHybirdCommandParams.swift
//  Pods
//

import UIKit

//MARK: 事件类型
enum MLHybridMethodType: String {
    
    case hybridInit             = "init"                //init - ( 初始化 )
    case hybridForward          = "forward"             //forward - (push 页面)
    case hybridModal            = "modal"               //modal - (modal 页面)
    case hybridBack             = "back"                //back - ( 返回上一页 )
    case hybridHeader           = "header"              //header - ( 导航栏 )
    case hybridScroll           = "scroll"              //scroll - ( 页面滚动 ,主要是回弹效果)
    case hybridPageshow         = "pageshow"            //pageshow - ( 页面显示 )
    case hybridPagehide         = "pagehide"            //pagehide - ( 页面隐藏 )
    case hybridDevice           = "device"              //device - ( 获取设备信息 )
    case hybridLocation         = "location"            //location - ( 定位 )
    case hybridClipboard        = "clipboard"           //clipboard - ( 剪贴板 )
    
    case UnKonw = "UnKonw"
}

open class MLHybirdCommandParams: NSObject {
    
    var dic: [String: AnyObject] = [:]                  //储存原始数据
    var commandParams:BaseParams = BaseParams.init()    //解析的对象
    
    //新的参数解析方式
    class func convert(_ dic: [String: AnyObject], nameType:MLHybridMethodType?) -> MLHybirdCommandParams {
        let args = MLHybirdCommandParams()
        args.dic = dic
        //如果传输不在范围内的命令，直接返回基类
        guard let name = nameType else {
            return args
        }
        
        //对不同参数进行解析
        switch name {
        case .hybridInit:
            args.commandParams = HybridInitParams.convert(dic)
        case .hybridForward:
            args.commandParams = HybridForwardParams.convert(dic)
        case .hybridModal:
            args.commandParams = HybridModalParams.convert(dic)
        case .hybridBack:
            args.commandParams = HybridBackParams.convert(dic)
        case .hybridHeader:
            args.commandParams = HybridHeaderParams.convert(dic)
        case .hybridScroll:
            args.commandParams = HybridScrollParams.convert(dic)
        case .hybridPageshow:
            args.commandParams = HybridPageshowParams.convert(dic)
        case .hybridPagehide:
            args.commandParams = HybridPagehideParams.convert(dic)
        case .hybridDevice:
            args.commandParams = HybridDeviceParams.convert(dic)
        case .hybridLocation:
            args.commandParams = HybridLocationParams.convert(dic)
        case .hybridClipboard:
            args.commandParams = HybridClipboardParams.convert(dic)
        default:
            break
        }
        return args
    }
}
//MARK: Class Params
//抽象基类 参数
class BaseParams: NSObject {
    //抽象方法
    class func convert(_ dic: [String: AnyObject]) -> BaseParams { return BaseParams.init()}
}
