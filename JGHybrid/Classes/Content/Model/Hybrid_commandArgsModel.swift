//
//  MLCommandArgsExtension.swift
//  JGHybrid
//
//  Created by 李保君 on 2017/11/24.
//

import UIKit

extension MLCommandArgs {
    
    //新的参数解析方式
    class func convert(_ dic: [String: AnyObject], nameType:MLHybridMethodType?) -> MLCommandArgs {
        let args = MLCommandArgs()
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
//init
class HybridInitParams: BaseParams {
    var cache:Bool = true                               //离线缓存，默认开启
    var callback_name:String = "Hybrid.callback"        //回调js方法名称
    //解析数据对象
    override class func convert(_ dic: [String: AnyObject]) -> HybridInitParams {
        let obj:HybridInitParams = HybridInitParams.init()
        obj.cache = dic["cache"] as? Bool ?? true
        obj.callback_name = dic["callback_name"] as? String ?? "Hybrid.callback"
        return obj
    }
}
//forward
class HybridForwardParams: BaseParams {
    var type:String = "h5"
    var url:String = ""
    var title:String = ""
    var animate:Bool = true
    //解析数据对象
    override class func convert(_ dic: [String: AnyObject]) -> HybridForwardParams {
        let obj:HybridForwardParams = HybridForwardParams.init()
        obj.type = dic["type"] as? String ?? "h5"
        obj.url = dic["url"] as? String ?? ""
        obj.title = dic["title"] as? String ?? ""
        obj.animate = dic["animate"] as? Bool ?? true
        return obj
    }
}
//modal
class HybridModalParams: BaseParams {
    var type:String = "h5"
    var url:String = ""
    var title:String = ""
    var animate:Bool = true
    //解析数据对象
    override class func convert(_ dic: [String: AnyObject]) -> HybridModalParams {
        let obj:HybridModalParams = HybridModalParams.init()
        obj.type = dic["type"] as? String ?? "h5"
        obj.url = dic["url"] as? String ?? ""
        obj.title = dic["title"] as? String ?? ""
        obj.animate = dic["animate"] as? Bool ?? true
        return obj
    }
}
//back
class HybridBackParams: BaseParams {
    var step:Int = 1
    //解析数据对象
    override class func convert(_ dic: [String: AnyObject]) -> HybridBackParams {
        let obj:HybridBackParams = HybridBackParams.init()
        obj.step = dic["step"] as? Int ?? 1
        return obj
    }
}

//header
class HybridHeaderParams: BaseParams {
    var title:String = ""
    var show:Bool = true
    var background:String = ""
    var left:[HybridHeaderButtonParams] = []
    var right:[HybridHeaderButtonParams] = []
    //解析数据对象
    override class func convert(_ dic: [String: AnyObject]) -> HybridHeaderParams {
        let obj:HybridHeaderParams = HybridHeaderParams.init()
        obj.title = dic["title"] as? String ?? ""
        obj.show = dic["show"] as? Bool ?? true
        obj.background = dic["background"] as? String ?? ""
        //左边Button
        if let leftArray:[[String: AnyObject]] = dic["left"] as? [[String: AnyObject]] {
            for leftSingle:[String: AnyObject] in leftArray {
                obj.left.append(HybridHeaderButtonParams.convert(leftSingle))
            }
        }
        //右边Button
        if let rightArray:[[String: AnyObject]] = dic["right"] as? [[String: AnyObject]] {
            for rightSingle:[String: AnyObject] in rightArray {
                obj.right.append(HybridHeaderButtonParams.convert(rightSingle))
            }
        }
        return obj
    }
    
    //Header 下的Button
    class HybridHeaderButtonParams : BaseParams{
        var title:String = ""
        var callback:String = ""
        var icon:String = ""
        var color:String = ""
        //解析数据对象
        override class func convert(_ dic: [String: AnyObject]) -> HybridHeaderButtonParams {
            let obj:HybridHeaderButtonParams = HybridHeaderButtonParams.init()
            obj.title = dic["title"] as? String ?? ""
            obj.callback = dic["callback"] as? String ?? ""
            obj.icon = dic["icon"] as? String ?? ""
            obj.color = dic["color"] as? String ?? ""
            return obj
        }
    }
    
}

//scroll
class HybridScrollParams: BaseParams {
    var enable:Bool = true
    var background:String = ""
    //解析数据对象
    override class func convert(_ dic: [String: AnyObject]) -> HybridScrollParams {
        let obj:HybridScrollParams = HybridScrollParams.init()
        obj.enable = dic["enable"] as? Bool ?? true
        obj.background = dic["background"] as? String ?? ""
        return obj
    }
}
//pageshow
class HybridPageshowParams: BaseParams {
    //解析数据对象
    override class func convert(_ dic: [String: AnyObject]) -> HybridPageshowParams {
        let obj:HybridPageshowParams = HybridPageshowParams.init()
        return obj
    }
}
//pagehide
class HybridPagehideParams: BaseParams {
    //解析数据对象
    override class func convert(_ dic: [String: AnyObject]) -> HybridPagehideParams {
        let obj:HybridPagehideParams = HybridPagehideParams.init()
        return obj
    }
}
//device
class HybridDeviceParams: BaseParams {
    //解析数据对象
    override class func convert(_ dic: [String: AnyObject]) -> HybridDeviceParams {
        let obj:HybridDeviceParams = HybridDeviceParams.init()
        return obj
    }
}
//location
class HybridLocationParams: BaseParams {
    var located:String = ""
    var failed:String = ""
    var updated:String = ""
    var precision:String = "normal"
    var timeout:Int32 = 5000
    //解析数据对象
    override class func convert(_ dic: [String: AnyObject]) -> HybridLocationParams {
        let obj:HybridLocationParams = HybridLocationParams.init()
        obj.located = dic["located"] as? String ?? ""
        obj.failed = dic["failed"] as? String ?? ""
        obj.updated = dic["updated"] as? String ?? ""
        obj.precision = dic["precision"] as? String ?? "normal"
        obj.timeout = dic["timeout"] as? Int32 ?? 5000
        return obj
    }
}
//clipboard
class HybridClipboardParams: BaseParams {
    var content:String = ""
    //解析数据对象
    override class func convert(_ dic: [String: AnyObject]) -> HybridClipboardParams {
        let obj:HybridClipboardParams = HybridClipboardParams.init()
        obj.content = dic["content"] as? String ?? ""
        return obj
    }
}





