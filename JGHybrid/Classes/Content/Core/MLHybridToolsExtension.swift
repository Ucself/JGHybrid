//
//  MLHybridToolsExtension.swift
//  JGHybrid
//
//  Created by 李保君 on 2017/11/24.
//

import UIKit

//新版的Hybrid解析
extension MLHybridTools {

    ///init - ( 初始化 )
    func HybridInit(){
        guard let param:HybridInitParams = self.command.args.commandParams as? HybridInitParams  else {
            return
        }
        Hybrid_constantModel.hybridEvent = param.callback_name
        UserDefaults.standard.set(!param.cache, forKey: Hybrid_constantModel.switchCache)
    }
}
