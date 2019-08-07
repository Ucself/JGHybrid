//
//  HeaderBusiness.swift
//  DoctorHealth
//
//  Created by 李保君 on 2018/12/26.
//  Copyright © 2018 doctorworker. All rights reserved.
//

import Foundation

extension HybridBusiness {
    //MARK: -`header协议`-
    
    /// header
    ///
    /// - Parameter command: command
    @objc open func header(command: HybridCommand) {
        let params:HybridHeaderParams = HybridHeaderParams.convert(command.params)
        command.args = params
        guard let vc:HybridViewController = command.viewController else {
            return
        }
        vc.titleName = params.title
        //设置导航栏是否显示
        //标题颜色
        if UIColor.hybridColorWithHex(params.color) != .clear {
            vc.titleColor = UIColor.hybridColorWithHex(params.color)
        }
        //设置背景色
        if UIColor.hybridColorWithHex(params.background) != .clear {
            //根据16进制获取颜色值
            vc.barTintColor = UIColor.hybridColorWithHex(params.background)
        }
        //设置左边按钮
        if params.left.count != 0 {
            let leftButtonItems:[UIBarButtonItem] = self.hybridHeaderLeftBarButtonItems(params.left, command)
            vc.navigationItem.setLeftBarButtonItems(leftButtonItems, animated: false)
        }
        //设置右边按钮
        if params.right.count != 0 {
            let rightButtonItems:[UIBarButtonItem] = self.hybridHeaderRightBarButtonItems(params.right, command)
            vc.navigationItem.setRightBarButtonItems(rightButtonItems, animated: true)
        }
        //回调
//        self.handleCallback(command)
    }
    
    /// 设置左边按钮
    ///
    /// - Parameter buttonModels: 数据模型
    /// - Returns:
    @objc private func hybridHeaderLeftBarButtonItems(_ buttonModels:[HybridHeaderParams.HybridHeaderButtonParams],_ command: HybridCommand) -> [UIBarButtonItem] {
        var barButtons:[UIBarButtonItem] = []
        for model:HybridHeaderParams.HybridHeaderButtonParams in buttonModels {
            //需要添加的item
            let barButtonItem:UIBarButtonItem = UIBarButtonItem.init()
            //覆盖一层view
            let coverView:UIView = UIView.init();coverView.backgroundColor = UIColor.clear
            //Button按钮
            let button:hybridHeaderButton = hybridHeaderButton.init()
            button.command = command
            
            let titleWidth = model.title.hybridStringWidthWith(15, height: 20)
            let itemWidth = titleWidth > 44 ? titleWidth : 44
            //这是大小
            coverView.frame = CGRect.init(x: 0, y: 0, width: itemWidth, height: 44)
            //设置颜色
            let titleColor:UIColor = UIColor.hybridColorWithHex(model.color)
            if titleColor != .clear {
                button.setTitleColor(titleColor, for: .normal)
            }
            
            //设置标题
            if model.title.count > 0 {
                button.setTitle(model.title, for: .normal)
            }
            //设置图片
            if model.icon != "" ,let buttonIcon:UIImage = UIImage.init(named: MLHybridConfiguration.default.imagePrefixes + model.icon){
                button.setImage(buttonIcon, for: .normal)
                coverView.frame = CGRect.init(x: 0, y: 0, width: 44, height: 44)
                button.setTitle("", for: .normal)
            }
            if model.title == "back" {
                let image = UIImage(named: MLHybridConfiguration.default.backIndicator)
                button.setImage(image, for: .normal)
            }
            //添加点击事件
            button.buttonModel = model
            button.addTarget(self, action: #selector(hybridHeaderButtonClick(sender:)), for: .touchUpInside)
            button.frame = coverView.frame
            button.backgroundColor = UIColor.clear
            button.contentHorizontalAlignment = .left
            button.contentVerticalAlignment = .center
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)
            coverView.addSubview(button)
            //设置View
            barButtonItem.customView = coverView
            //添加到数组
            barButtons.append(barButtonItem)
        }
        
        //        let spaceBar = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        //        spaceBar.width = 6
        //        barButtons.insert(spaceBar, at: 0)
        return barButtons
    }
    /// 设置右边按钮
    ///
    /// - Parameter buttonModels: 数据模型
    /// - Returns:
    @objc private func hybridHeaderRightBarButtonItems(_ buttonModels:[HybridHeaderParams.HybridHeaderButtonParams],_ command: HybridCommand) -> [UIBarButtonItem] {
        var barButtons:[UIBarButtonItem] = []
        for model:HybridHeaderParams.HybridHeaderButtonParams in buttonModels {
            //需要添加的item
            let barButtonItem:UIBarButtonItem = UIBarButtonItem.init()
            //覆盖一层view
            let coverView:UIView = UIView.init();coverView.backgroundColor = UIColor.clear
            //Button按钮
            let button:hybridHeaderButton = hybridHeaderButton.init()
            button.command = command
            
            let titleWidth = model.title.hybridStringWidthWith(15, height: 20)
            let itemWidth = titleWidth > 44 ? titleWidth : 44
            //这是大小
            coverView.frame = CGRect.init(x: 0, y: 0, width: itemWidth, height: 44)
            //设置颜色
            let titleColor:UIColor = UIColor.hybridColorWithHex(model.color)
            if titleColor != .clear {
                button.setTitleColor(titleColor, for: .normal)
            }
            
            //设置标题
            if model.title.count > 0 {
                button.setTitle(model.title, for: .normal)
            }
            //设置图片
            if model.icon != "" ,let buttonIcon:UIImage = UIImage.init(named: MLHybridConfiguration.default.imagePrefixes + model.icon){
                button.setImage(buttonIcon, for: .normal)
                coverView.frame = CGRect.init(x: 0, y: 0, width: 44, height: 44)
                button.setTitle("", for: .normal)
            }
            if model.title == "back" {
                let image = UIImage(named: MLHybridConfiguration.default.backIndicator)
                button.setImage(image, for: .normal)
            }
            //添加点击事件
            button.buttonModel = model
            button.addTarget(self, action: #selector(hybridHeaderButtonClick(sender:)), for: .touchUpInside)
            //添加到数组
            barButtonItem.customView = coverView
            button.frame = coverView.frame
            button.backgroundColor = UIColor.clear
            button.contentHorizontalAlignment = .right
            button.contentVerticalAlignment = .center
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 6)
            coverView.addSubview(button)
            barButtons.append(barButtonItem)
        }
        
        //        let spaceBar = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        //        spaceBar.width = 6
        //        barButtons.insert(spaceBar, at: 0)
        
        return barButtons
    }
    
    /// HeaderButton
    @objc private class hybridHeaderButton: UIButton {
        var command: HybridCommand?
        var buttonModel:HybridHeaderParams.HybridHeaderButtonParams = HybridHeaderParams.HybridHeaderButtonParams()
    }
    
    /// HeaderButton点击回调
    ///
    /// - Parameter sender: hybridHeaderButton
    @objc private func hybridHeaderButtonClick(sender: hybridHeaderButton) {
        sender.command?.callBack(callback:  sender.buttonModel.callback) { (str) in }
    }
    
}
