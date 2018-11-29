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
    
    //init - ( 初始化 )
    func hybridInit(){
    }
    //forward - (push 页面 )
    func hybridForward(){
    }
    ////modal - (modal 页面)
    func hybridModal(){
        
    }
    
    ////modal - (modal 页面 dismiss)
    func hybridDismiss(){
        
    }
    //back - ( 返回上一页 )
    func hybridBack(){
        
    }
    //header - ( 导航栏 )
    func hybridHeader(){
        
        
    }
    
    //scroll - ( 页面滚动 ,主要是回弹效果)
    func hybridScroll(){
        
    }
    //pageshow - ( 页面显示 )
    func hybridPageshow() {
        
    }
    //pagehide - ( 页面隐藏 )
    func hybridPagehide() {
        
    }
    //device - ( 获取设备信息 )
    func hybridDevice() {
        
    }
    //location - ( 定位 )
    func hybridLocation(){
        
    }
    //clipboard - ( 剪贴板 )
    func hybridStorage(){
        
    }
    //clipboard - ( 剪贴板 )
    func hybridClipboard(){
        guard let params:HybridClipboardParams = self.command.args.commandParams as? HybridClipboardParams  else {
            return
        }
        UIPasteboard.general.string = params.content
    }

    
}

