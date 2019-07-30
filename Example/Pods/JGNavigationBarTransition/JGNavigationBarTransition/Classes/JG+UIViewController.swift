//
//  JG+UIViewController.swift
//  JGNavigationBarTransition_Example
//
//  Created by 李保君 on 2019/7/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

// MARK: - UIViewController
extension UIViewController : MethodExchangeProtocol{
    
    //运行时导入属性key
    fileprivate struct AssociatedKeys
    {
        static var navBarBarTintColorKey: String = "navBarBarTintColorKey"
        static var navBarTitleColorKey: String = "navBarTitleColorKey"
        static var navBarBackgroundAlphaKey: String = "navBarBackgroundAlphaKey"
        static var navBarTintColorKey: String = "navBarTintColorKey"
        static var navBarBackgroundImageKey: String = "navBarBackgroundImageKey"
        static var statusBarStyle: String = "statusBarStyle"
        static var navBarShadowImageHidden: String = "navBarShadowImageHidden"
    }
    
    /// 导航栏颜色
    public var jg_navBarBarTintColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.navBarBarTintColorKey) as? UIColor
        }
        set {
            if newValue != nil {
                objc_setAssociatedObject(self, &AssociatedKeys.navBarBarTintColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                navigationController?.navigationBar.jg_setBarTintColor(color: newValue!)
            }
        }
    }
    
    /// 标题颜色
    public var jg_navBarTitleColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.navBarTitleColorKey) as? UIColor
        }
        set {
            if newValue != nil {
                objc_setAssociatedObject(self, &AssociatedKeys.navBarTitleColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                navigationController?.navigationBar.jg_setTitleColor(color: newValue!)
            }
        }
    }
    
    /// 导航栏透明度
    public var jg_navBarBackgroundAlpha:CGFloat? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.navBarBackgroundAlphaKey) as? CGFloat
        }
        set {
            if newValue != nil {
                objc_setAssociatedObject(self, &AssociatedKeys.navBarBackgroundAlphaKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                navigationController?.navigationBar.jg_setBackgroundAlpha(alpha: newValue!)
            }
        }
    }
    
    /// 导航栏主题色（默认系统按钮，标题等等）
    public var jg_navBarTintColor:UIColor? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.navBarTintColorKey) as? UIColor
        }
        set {
            if newValue != nil {
                objc_setAssociatedObject(self, &AssociatedKeys.navBarTintColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                navigationController?.navigationBar.jg_setTintColor(color: newValue!)
            }
        }
    }
    
    /// 导航栏背景图片 ，弃用使用场景不适合
    //    var jg_navBarBackgroundImage:UIImage? {
    //        get {
    //            return objc_getAssociatedObject(self, &AssociatedKeys.navBarBackgroundImageKey) as? UIImage
    //        }
    //        set {
    //            if newValue != nil {
    //                objc_setAssociatedObject(self, &AssociatedKeys.navBarBackgroundImageKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    //                navigationController?.navigationBar.jg_setBackgroundImage(image: newValue!)
    //            }
    //        }
    //    }
    
    /// 设置装填栏颜色
    public var jg_statusBarStyle:UIStatusBarStyle? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.statusBarStyle) as? UIStatusBarStyle
        }
        set {
            if newValue != nil {
                objc_setAssociatedObject(self, &AssociatedKeys.statusBarStyle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    
    public var jg_navBarShadowImageHidden:Bool? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.navBarShadowImageHidden) as? Bool
        }
        set {
            if newValue != nil {
                objc_setAssociatedObject(self, &AssociatedKeys.navBarShadowImageHidden, newValue, .OBJC_ASSOCIATION_ASSIGN)
                navigationController?.navigationBar.jg_navBarShadowImageHidden(hideShadowImage: newValue!)
            }
        }
    }
    
    // call swizzling methods active 主动调用交换方法
    private static let onceToken = UUID().uuidString
    @objc public static func methodExchange()
    {
        DispatchQueue.once(token: onceToken)
        {
            let needSwizzleSelectors = [
                #selector(viewWillAppear(_:)),
                #selector(viewWillDisappear(_:)),
                #selector(viewDidAppear(_:))
            ]
            
            for selector in needSwizzleSelectors
            {
                let newSelectorStr = "jg_" + selector.description
                if let originalMethod = class_getInstanceMethod(self, selector),
                    let swizzledMethod = class_getInstanceMethod(self, Selector(newSelectorStr)) {
                    method_exchangeImplementations(originalMethod, swizzledMethod)
                }
            }
        }
    }
    @objc func jg_viewWillAppear(_ animated: Bool)
    {
        //print("\(self) => jg_viewWillAppear; count = \(self.navigationController?.viewControllers.count ?? 0)")
        //设置NavigationBar 背景色
        if jg_navBarBarTintColor != nil {
            navigationController?.navigationBar.jg_setBarTintColor(color: jg_navBarBarTintColor!)
        }
        //设置NavigationBar title 颜色
        if jg_navBarTitleColor != nil {
            navigationController?.navigationBar.jg_setTitleColor(color: jg_navBarTitleColor!)
        }
        
        jg_viewWillAppear(animated)
    }
    
    @objc func jg_viewWillDisappear(_ animated: Bool)
    {
        //print("\(self) => jg_viewWillDisappear; count = \(self.navigationController?.viewControllers.count ?? 0)")
        jg_viewWillDisappear(animated)
    }
    
    @objc func jg_viewDidAppear(_ animated: Bool)
    {
        //print("\(self) => jg_viewDidAppear; count = \(self.navigationController?.viewControllers.count ?? 0)")
        //设置NavigationBar 背景色
        if jg_navBarBarTintColor != nil {
            navigationController?.navigationBar.jg_setBarTintColor(color: jg_navBarBarTintColor!)
        }
        //设置NavigationBar title 颜色
        if jg_navBarTitleColor != nil {
            navigationController?.navigationBar.jg_setTitleColor(color: jg_navBarTitleColor!)
        }
        //设置NavigationBar 透明度
        if jg_navBarBackgroundAlpha != nil {
            navigationController?.navigationBar.jg_setBackgroundAlpha(alpha: jg_navBarBackgroundAlpha!)
        }
        //设置NavigationBar 导航栏主题色
        if jg_navBarTintColor != nil {
            navigationController?.navigationBar.jg_setTintColor(color: jg_navBarTintColor!)
        }
        //设置NavigationBar 导航栏横线阴影
        if jg_navBarShadowImageHidden != nil {
            navigationController?.navigationBar.jg_navBarShadowImageHidden(hideShadowImage: jg_navBarShadowImageHidden!)
        }
        
        jg_viewDidAppear(animated)
    }
}
