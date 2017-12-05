//
//  MLHybridMethodType.swift
//  Pods
//

import Foundation

//MARK: 事件类型
enum MLHybridMethodType: String {
    //New
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
    //Old
    case UpdateHeader = "updateheader"
    //case Back = "back"
    //case Forward = "forward"
    case ShowHeader = "showheader"
    case CheckVersion = "checkver"
    case OnWebViewShow = "onwebviewshow"
    case OnWebViewHide = "onwebviewhide"
    case SwitchCache = "switchcache"
    case CurrentPosition = "getcurlocpos"
    case CopyLink = "copyLink"
    case GetLocation = "getLocation"
    case Pop = "pop"
    case Openlink = "openLink"
    case Addtoclipboard = "addtoclipboard"
    case UnKonw = "UnKonw"
}



