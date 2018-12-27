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
extension HybridCommandExecute {
    //MARK: 离线包
    func hybridOfflinePackage(){
        //异步请求
        DispatchQueue.global().async {
            //请求会话
            let session:URLSession = URLSession.shared
            guard let url:URL = URL.init(string: MLHybridConfiguration.default.offlinePackageJsonUrl) else { return }
            let task:URLSessionTask = session.dataTask(with: url) { (data, response, error) in
                //数据文件逻辑判断
                HybridCacheManager.default.hybridOfflinePackageJson(data: data)
            }
            task.resume()
        }
    }
    
}

