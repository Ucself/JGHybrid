//
//  HybridCacheManager.swift
//  JGHybrid
//
//  Created by Frank Li on 2018/6/13.
//

import UIKit
import SSZipArchive

class HybridCacheManager: NSObject {
    static let `default` = HybridCacheManager()
    
    func downZipAndUnzip(urlString:String, downloadPath: String, savePath: String, unzipPath: String,downLoadComplet:((_ success:Bool,_ msg:String)->Void)?=nil , unzipComplet:((_ success:Bool,_ msg:String)->Void)?=nil) {
        guard let url = URL.init(string: urlString) else { return }
        DispatchQueue.global().async {
            let session:URLSession = URLSession.shared
            let task:URLSessionTask = session.dataTask(with: url) { [weak self] (data, response, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        downLoadComplet?(false,error?.localizedDescription ?? "")
                    }
                    return
                }
                guard let weakSelf = self, let responseData = data else {
                    DispatchQueue.main.async {
                        downLoadComplet?(false,"获取数据失败")
                    }
                    return
                }
                
                downLoadComplet?(true,"")
                weakSelf.deleteAllFiles(path: unzipPath)
                
                if (try? responseData.write(to: URL(fileURLWithPath: savePath), options: [.atomic])) != nil {
                    let tag = weakSelf.unzip(zipPath: savePath, toDestination: unzipPath)
                    if tag == true {
                        weakSelf.deleteAllFiles(path: savePath)
                        DispatchQueue.main.async {
                            unzipComplet?(true, "")
                        }
                    } else {
                        DispatchQueue.main.async {
                            unzipComplet?(false, "解压失败 \(savePath)")
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        unzipComplet?(false, "写入失败 \(savePath)")
                    }
                }
            }
            task.resume()
        }
    }
    
    private func unzip(zipPath: String, toDestination: String) -> Bool {
        let tag = SSZipArchive.unzipFile(atPath: zipPath, toDestination: toDestination)
        return tag
    }
    
    private func deleteAllFiles(path: String) {
        do {
            if let fileArray : [AnyObject] = FileManager.default.subpaths(atPath: path) as [AnyObject]? {
                for file in fileArray {
                    if FileManager.default.fileExists(atPath: path + "/\(file)") {
                        try FileManager.default.removeItem(atPath: path + "/\(file)")
                    }
                }
            }
            if FileManager.default.fileExists(atPath: path) {
                try FileManager.default.removeItem(atPath: path)
            }
        } catch {
            print("删除H5缓存文件失败")
        }
    }
    
    //H5 版本问题
    func hybridOfflinePackageJson(data:Data?) {
        //获取返回的数据
        guard let responseData = data else { return }
        // 本地配置
        guard let defaultDic = self.getDefaultConfig() as? [[String:AnyObject]] else { return }
        //返回的data 转换为 字典
        let jsonData = dataToDic(data: responseData)
        
        guard let offlineDic = jsonData as? [[String:AnyObject]] else { return }
        //判断数组个数
        guard offlineDic.count >= 1 else { return }
        //本地配置转换
        let defaultParams:HybridOfflinePackageJsonParams = HybridOfflinePackageJsonParams.convert(defaultDic[0])
        //字典转换为对象
        let offlinePackageJsonParams:HybridOfflinePackageJsonParams = HybridOfflinePackageJsonParams.convert(offlineDic[0])
        
        //版本检测
        if defaultParams.version < offlinePackageJsonParams.version {
            //写入新的配置
            self.writeNewConfig(data: responseData)
            //下载并解压
            for itemSource:HybridOfflinePackageSourceParams in offlinePackageJsonParams.source {
                
                //下载路径
                downZipAndUnzip(urlString: itemSource.bundle,
                                downloadPath: hybridAbsolutePath(),
                                savePath: hybridAbsolutePath() + "/\(itemSource.key).zip",
                    unzipPath: hybridAbsolutePath() + "/\(itemSource.name)",
                    downLoadComplet: { [weak self] (success, errorMsg) in
                        guard let _self = self else { return }
                        if success {
                            
                        } else {
                            
                        }
                }) {  [weak self] (success, errorMsg) in
                    guard let _self = self else { return }
                }
            }
        }
    }
    
    private func writeNewConfig(data: Data) {
        let path = getNewResourcesJsonPath()
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: path) {
            fileManager.createFile(atPath: path, contents:nil, attributes:nil)
        }
        let file = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        
        let handle = FileHandle(forWritingAtPath:path)
        handle?.write(data)
    }
    
    private func getDefaultConfig() -> Any? {
        var filePath: String?
        let fileManager = FileManager.default
        let path = getNewResourcesJsonPath()
        if fileManager.fileExists(atPath: path) {
            filePath = path
        } else {
            filePath = Bundle.main.path(forResource: "resources", ofType: "json")
        }
        guard let jsonPath = filePath else { return nil }
        let data = NSData.init(contentsOfFile: jsonPath)
        return dataToDic(data: data as! Data)
    }
    
    func getNewResourcesJsonPath () -> String {
        let fileName = "newResources.json"
        return hybridAbsolutePath() + "/" + fileName
    }
    
    func dataToDic(data: Data) -> Any? {
        do {
            let dic = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            return dic
        } catch let catchError {
            print("hybridOfflinePackageJson.catchError -> \(catchError)")
            return nil
        }
    }
    
    func hybridAbsolutePath () -> String {
        return NSHomeDirectory() + "/Documents/" + HybridConstantDefineOfflinePackageFolder
    }
    
    //解压项目中的文件
    func HybridUnzipHybiryOfflineZip(){
        guard let zipPath = Bundle.main.path(forResource: HybridConstantDefineOfflinePackageFolder, ofType: "zip") else { return }
        if !FileManager.default.fileExists(atPath: hybridAbsolutePath()) {
            DispatchQueue.global().async {
                let documentPath = NSHomeDirectory() + "/Documents"
                self.unzip(zipPath: zipPath, toDestination: documentPath)
            }
        }
    }
}
