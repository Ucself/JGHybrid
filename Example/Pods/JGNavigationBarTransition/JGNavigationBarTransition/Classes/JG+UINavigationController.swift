//
//  JG+UINavigationController.swift
//  JGNavigationBarTransition_Example
//
//  Created by 李保君 on 2019/7/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

// MARK: - UINavigationController
extension UINavigationController : MethodExchangeNavProtocol{
    
    // MARK: - call swizzling methods active 主动调用交换方法
    private static let onceToken = UUID().uuidString
    @objc public static func methodExchangeNav()
    {
        DispatchQueue.once(token: onceToken)
        {
            let needSwizzleSelectorArr = [
                NSSelectorFromString("_updateInteractiveTransition:"),
                #selector(popToViewController),
                #selector(popToRootViewController),
                #selector(pushViewController)
            ]
            
            for selector in needSwizzleSelectorArr {
                // _updateInteractiveTransition:  =>  jg_updateInteractiveTransition:
                let str = ("jg_" + selector.description).replacingOccurrences(of: "__", with: "_")
                if let originalMethod = class_getInstanceMethod(self, selector),
                    let swizzledMethod = class_getInstanceMethod(self, Selector(str)) {
                    method_exchangeImplementations(originalMethod, swizzledMethod)
                }
            }
        }
    }
    
    // swizzling system method: _updateInteractiveTransition
    @objc func jg_updateInteractiveTransition(_ percentComplete: CGFloat)
    {
        //print("\(self) => jg_updateInteractiveTransition; percentComplete => \(percentComplete)")
        guard let topViewController = topViewController,let coordinator = topViewController.transitionCoordinator else {
            jg_updateInteractiveTransition(percentComplete)
            return
        }
        
        let fromVC = coordinator.viewController(forKey: .from)
        let toVC = coordinator.viewController(forKey: .to)
        updateNavigationBar(fromVC: fromVC, toVC: toVC, progress: percentComplete)
        
        jg_updateInteractiveTransition(percentComplete)
    }
    
    // swizzling system method: popToViewController
    @objc func jg_popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]?
    {
        //print("\(self) => jg_popToViewController; vc = \(viewController); count = \(self.viewControllers.count)")
        let vcs = jg_popToViewController(viewController, animated: animated)
        return vcs
    }
    
    // swizzling system method: popToRootViewControllerAnimated
    @objc func jg_popToRootViewControllerAnimated(_ animated: Bool) -> [UIViewController]?
    {
        //print("\(self) => jg_popToRootViewControllerAnimated; count = \(self.viewControllers.count)")
        let vcs = jg_popToRootViewControllerAnimated(animated)
        return vcs;
    }
    // swizzling system method: pushViewController
    @objc func jg_pushViewController(_ viewController: UIViewController, animated: Bool)
    {
        //print("\(self) => jg_pushViewController; vc = \(viewController); count = \(self.viewControllers.count)")
        jg_pushViewController(viewController, animated: animated)
    }
    
    // MARK: - extension methods
    // 更新导航栏
    fileprivate func updateNavigationBar(fromVC: UIViewController?, toVC: UIViewController?, progress: CGFloat)
    {
        // 改变透明度
        if let fromBarBackgroundAlpha = fromVC?.jg_navBarBackgroundAlpha,let toBarBackgroundAlpha = toVC?.jg_navBarBackgroundAlpha {
            let newBarBackgroundAlpha = self.middleAlpha(fromAlpha: fromBarBackgroundAlpha, toAlpha: toBarBackgroundAlpha, percent: progress)
            self.navigationBar.jg_setBackgroundAlpha(alpha: newBarBackgroundAlpha)
        }
        // 改变主题色
        if let fromTintColor = fromVC?.jg_navBarTintColor,let toTintColor = toVC?.jg_navBarTintColor {
            let newTintColor = self.middleColor(fromColor: fromTintColor, toColor: toTintColor, percent: progress)
            self.navigationBar.jg_setTintColor(color: newTintColor)
        }
    }
    /// 根据转场值修改透明度值
    fileprivate func middleAlpha(fromAlpha: CGFloat, toAlpha: CGFloat, percent: CGFloat) -> CGFloat
    {
        let newAlpha = fromAlpha + (toAlpha - fromAlpha) * percent
        return newAlpha
    }
    /// 根据转场值修改a颜色值
    fileprivate func middleColor(fromColor: UIColor, toColor: UIColor, percent: CGFloat) -> UIColor
    {
        // get current color RGBA
        var fromRed: CGFloat = 0
        var fromGreen: CGFloat = 0
        var fromBlue: CGFloat = 0
        var fromAlpha: CGFloat = 0
        fromColor.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        
        // get to color RGBA
        var toRed: CGFloat = 0
        var toGreen: CGFloat = 0
        var toBlue: CGFloat = 0
        var toAlpha: CGFloat = 0
        toColor.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
        
        // calculate middle color RGBA
        let newRed = fromRed + (toRed - fromRed) * percent
        let newGreen = fromGreen + (toGreen - fromGreen) * percent
        let newBlue = fromBlue + (toBlue - fromBlue) * percent
        let newAlpha = fromAlpha + (toAlpha - fromAlpha) * percent
        return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: newAlpha)
    }
    
    // MARK: - override methods
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.jg_statusBarStyle ?? .default
    }
}
