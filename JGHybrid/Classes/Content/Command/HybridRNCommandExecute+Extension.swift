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
    func hybridInit() -> Any? {
        return nil
    }
    //forward - (push 页面 )
    func hybridForward() -> Any?{
        guard let params:HybridForwardParams = self.command.args.commandParams as? HybridForwardParams  else {
            return nil
        }
        if params.type == "h5" {
            guard let webViewController = MLHybrid.load(urlString: params.url) else {return nil}
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
            
            return webViewController
        } else {
            //native跳转交给外部处理
            command.name = "forwardNative"
            return MLHybrid.shared.delegate?.commandRNExtension(rnCommand: self.command)
        }
    }
    ////modal - (modal 页面)
    func hybridModal() -> Any? {
        return nil
    }
    
    ////modal - (modal 页面 dismiss)
    func hybridDismiss() -> Any? {
        return nil
    }
    //back - ( 返回上一页 )
    func hybridBack() -> Any? {
        return nil
    }
    //header - ( 导航栏 )
    func hybridHeader() -> Any? {
        return nil
    }
    
    //scroll - ( 页面滚动 ,主要是回弹效果)
    func hybridScroll() -> Any? {
        return nil
    }
    //pageshow - ( 页面显示 )
    func hybridPageshow() -> Any?  {
        return nil
    }
    //pagehide - ( 页面隐藏 )
    func hybridPagehide() -> Any?  {
        return nil
    }
    //device - ( 获取设备信息 )
    func hybridDevice() -> Any?  {
        return nil
    }
    //location - ( 定位 )
    func hybridLocation() -> Any? {
        return nil
    }
    //clipboard - ( 剪贴板 )
    func hybridStorage() -> Any? {
        return nil
    }
    //clipboard - ( 剪贴板 )
    func hybridClipboard() -> Any? {
        guard let params:HybridClipboardParams = self.command.args.commandParams as? HybridClipboardParams  else {
            return nil
        }
        UIPasteboard.general.string = params.content
        return nil
    }

    
}

