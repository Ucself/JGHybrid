//
//  JGNavigationBar.swift
//  JGNavigationBarTransition
//
//  Created by ucself
//
//  Github地址：https://github.com/Ucself/JGNavigationBarTransition

import UIKit

class JGNavigationBar {
    //判断刘海儿屏手机
    class func isiPhoneXScreen() -> Bool {
        guard #available(iOS 11.0, *) else {
            return false
        }
        let windows:[UIWindow] = UIApplication.shared.windows
        if windows.count <= 0 {
            return false
        }
        return windows[0].safeAreaInsets.bottom > 0
    }
}

// MARK: - UIApplication
extension UIApplication {
    //执行一次方法交换
    //    public static func runOnce() {
    //        UINavigationBar.methodExchange()
    //        UIViewController.methodExchange()
    //        UINavigationController.methodExchangeNav()
    //    }
    //使用静态属性以保证只调用一次(该属性是个方法)
    public static let runOnce:Void = {
        UINavigationBar.methodExchange()
        UIViewController.methodExchange()
        UINavigationController.methodExchangeNav()
    }()
    //重写next属性
    open override var next: UIResponder?{
        UIApplication.runOnce
        return super.next
    }
}


// MARK: - DispatchQueue
extension DispatchQueue {
    
    private static var onceTracker = [String]()
    //Executes a block of code, associated with a unique token, only once.  The code is thread safe and will only execute the code once even in the presence of multithreaded calls.
    public class func once(token: String, block: () -> Void)
    {
        // 保证被 objc_sync_enter 和 objc_sync_exit 包裹的代码可以有序同步地执行
        objc_sync_enter(self)
        defer { // 作用域结束后执行defer中的代码
            objc_sync_exit(self)
        }
        if onceTracker.contains(token) {
            return
        }
        onceTracker.append(token)
        block()
    }
}

// MARK: - Protocol
// 定义方法交换协议
public protocol MethodExchangeProtocol: class {
    static func methodExchange()
}
public protocol MethodExchangeNavProtocol: class {
    static func methodExchangeNav()
}
