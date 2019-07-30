//
//  JG+UINavigationBar.swift
//  JGNavigationBarTransition_Example
//
//  Created by 李保君 on 2019/7/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

// MARK: - UINavigationBar
extension UINavigationBar : MethodExchangeProtocol{
    
    private struct AssociatedKeys {
        static var backgroundImageViewKey: String = "backgroundImageViewKey"
    }
    
    private var backgroundImageView:UIImageView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.backgroundImageViewKey) as? UIImageView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.backgroundImageViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // set navigationBar backgroundImage
    func jg_setBackgroundImage(image:UIImage)
    {
        let navBarHeight =  JGNavigationBar.isiPhoneXScreen() ? 88 : 64;
        if (backgroundImageView == nil)
        {
            setBackgroundImage(UIImage(), for: .default)
            backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: Int(bounds.width), height: navBarHeight))
            backgroundImageView!.contentMode = .scaleAspectFill
            backgroundImageView!.clipsToBounds = true
            subviews.first?.insertSubview(backgroundImageView ?? UIImageView(), at: 0)
        }
        backgroundImageView!.image = image
    }
    
    // 导航栏颜色
    func jg_setBarTintColor(color:UIColor)
    {
        barTintColor = color
    }
    // 标题颜色
    func jg_setTitleColor(color:UIColor)
    {
        guard let oldTitleTextAttributes = self.titleTextAttributes else {
            self.titleTextAttributes = [NSAttributedString.Key.foregroundColor:color]
            return
        }
        var newTitleTextAttributes = oldTitleTextAttributes
        newTitleTextAttributes.updateValue(color, forKey: NSAttributedString.Key.foregroundColor)
        self.titleTextAttributes = newTitleTextAttributes
    }
    // 透明度
    func jg_setBackgroundAlpha(alpha:CGFloat)
    {
        if let barBackgroundView = subviews.first
        {
            if #available(iOS 11.0, *)
            {   // sometimes we can't change _UIBarBackground alpha
                for view in barBackgroundView.subviews {
                    view.alpha = alpha
                }
            } else {
                barBackgroundView.alpha = alpha
            }
        }
    }
    // 导航栏主题颜色
    func jg_setTintColor(color:UIColor)
    {
        tintColor = color
    }
    
    // 导航栏横线阴影
    func jg_navBarShadowImageHidden(hideShadowImage:Bool){
        self.shadowImage = (hideShadowImage == true) ? UIImage() : nil
    }
    
    // call swizzling methods active 主动调用交换方法
    private static let onceToken = UUID().uuidString
    public static func methodExchange()
    {
        DispatchQueue.once(token: onceToken)
        {
            let needSwizzleSelectorArr = [
                #selector(setter: titleTextAttributes)
            ]
            
            for selector in needSwizzleSelectorArr {
                let str = ("jg_" + selector.description)
                if let originalMethod = class_getInstanceMethod(self, selector),
                    let swizzledMethod = class_getInstanceMethod(self, Selector(str)) {
                    method_exchangeImplementations(originalMethod, swizzledMethod)
                }
            }
        }
    }
    
    @objc func jg_setTitleTextAttributes(_ newTitleTextAttributes:[String : Any]?)
    {
        //print("\(self) => jg_setTitleTextAttributes ")
        jg_setTitleTextAttributes(newTitleTextAttributes)
    }
}
