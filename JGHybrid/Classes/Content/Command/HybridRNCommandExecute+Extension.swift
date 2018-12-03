//
//  MLHybridToolsExtension.swift
//  JGHybrid
//
//  Created by 李保君 on 2017/11/24.
//

import UIKit
import WebKit
import SSZipArchive

//新版的Hybrid解析
extension HybridRNCommandExecute {
    
    /// RN暂时没有实现的必要
    func hybridInit(){
        //回调
        self.command.callback?([])
    }
    //forward - (push 页面 )
    func hybridForward(){
        guard let params:HybridForwardParams = self.command.args.commandParams as? HybridForwardParams  else {
            self.command.callback?([])
            return
        }
        if params.type == "h5" {
            guard let webViewController = MLHybrid.load(urlString: params.url) else {
                self.command.callback?([])
                return
            }
            webViewController.titleName = params.title
            //标题颜色
            if UIColor.hybridColorWithHex(params.color) != .clear {
                webViewController.titleColor = UIColor.hybridColorWithHex(params.color)
            }
            //标题背景
            if UIColor.hybridColorWithHex(params.background) != .clear {
                webViewController.titleBackgroundColor = UIColor.hybridColorWithHex(params.background)
            }
            //如果是全屏，则为透明色
            if params.fullscreen {
                webViewController.isFullScreen = params.fullscreen
            }
            //是否需要返回手势
            if params.fullscreenBackGestures {
                webViewController.needFullScreenBackGestures = params.fullscreenBackGestures
            }
            //回调
            self.command.callback?([webViewController])
        } else {
            //native跳转交给外部处理
            command.name = "forwardNative"
            if let result = MLHybrid.shared.delegate?.commandRNExtension(rnCommand: self.command) {
                //回调
                self.command.callback?([result])
            }
            else {
                //回调
                self.command.callback?([])
            }
        }
    }
    ////modal - (modal 页面)
    func hybridModal() {
        guard let params:HybridModalParams = self.command.args.commandParams as? HybridModalParams  else {
            self.command.callback?([])
            return
        }
        if params.type == "h5" {
            guard let webViewController = MLHybrid.load(urlString: params.url) else {
                self.command.callback?([])
                return
            }
            webViewController.title = params.title
            //是否全屏
            if params.fullscreen {
                webViewController.isFullScreen = params.fullscreen
            }
            //回调
            self.command.callback?([webViewController])
        } else {
            //native跳转交给外部处理
            command.name = "modalNative"
            if let result = MLHybrid.shared.delegate?.commandRNExtension(rnCommand: self.command) {
                //回调
                self.command.callback?([result])
            }
            else {
                //回调
                self.command.callback?([])
            }
        }
    }
    
    ////modal - (modal 页面 dismiss)
    func hybridDismiss() {
        //回调
        self.command.callback?([])
    }
    //back - ( 返回上一页 )
    func hybridBack() {
        //回调
        self.command.callback?([])
    }
    //header - ( 导航栏 )
    func hybridHeader(){
        //回调
        self.command.callback?([])
    }
    
    //scroll - ( 页面滚动 ,主要是回弹效果)
    func hybridScroll(){
        //回调
        self.command.callback?([])
    }
    //pageshow - ( 页面显示 )
    func hybridPageshow() {
        //回调
        self.command.callback?([])
    }
    //pagehide - ( 页面隐藏 )
    func hybridPagehide() {
        //回调
        self.command.callback?([])
    }
    //device - ( 获取设备信息 )
    func hybridDevice() {
        let deviceInfor:[String:String] = ["version":"",
                                           "os":UIDevice.current.systemName,
                                           "dist":"app store",
                                           "uuid":UUID.init().uuidString]
        //回调
        self.command.callback?([deviceInfor])
    }
    //location - ( 定位 )
    func hybridLocation() {
        let locationModel = MLHybridLocation()
        locationModel.getLocation { (success, errcode, resultData) in
            let result:[String:Any] = ["success" : success , "errcode" : errcode, "data": resultData as Any]
            self.command.callback?([result])
        }
    }
    //clipboard - ( 存储 )
    func hybridStorage() {
        guard let params:HybridStorageParams = self.command.args.commandParams as? HybridStorageParams  else {
            self.command.callback?([])
            return
        }
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
            }
        case "get":
            //获取存储
            if let hashDic:[String:String] = UserDefaults.standard.object(forKey: userDefaultKey) as? [String:String] {
                self.command.callback?([hashDic])
            }
            else {
                self.command.callback?([])
            }
            
        case "remove":
            UserDefaults.standard.removeObject(forKey: userDefaultKey)
            self.command.callback?([])
        default:
            break
        }
    }
    //clipboard - ( 剪贴板 )
    func hybridClipboard() {
        guard let params:HybridClipboardParams = self.command.args.commandParams as? HybridClipboardParams  else {
            self.command.callback?([])
            return
        }
        UIPasteboard.general.string = params.content
        self.command.callback?([])
    }

    
}

