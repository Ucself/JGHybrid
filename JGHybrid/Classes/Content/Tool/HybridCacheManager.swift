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
    
    func downZip(name:String, urlString:String, complet:((_ success:Bool,_ msg:String)->Void)?=nil) {
        guard let url = URL.init(string: urlString) else { return }
        DispatchQueue.global().async {
            let session:URLSession = URLSession.shared
            let task:URLSessionTask = session.dataTask(with: url) { [weak self] (data, response, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        complet?(false,error?.localizedDescription ?? "")
                    }
                    return
                }
                guard let weakSelf = self, let responseData = data else {
                    DispatchQueue.main.async {
                        complet?(false,"获取数据失败")
                    }
                    return
                }
                let filePath = weakSelf.filePath(name: name)
                let zipPath = filePath + ".zip"
                weakSelf.deleteAllFiles(path: filePath)
                if (try? responseData.write(to: URL(fileURLWithPath: zipPath), options: [.atomic])) != nil {
                    let tag = SSZipArchive.unzipFile(atPath: zipPath, toDestination: filePath)
                    if tag == true {
                        weakSelf.deleteAllFiles(path: zipPath)
                        DispatchQueue.main.async {
                            complet?(true, "")
                        }
                    } else {
                        DispatchQueue.main.async {
                            complet?(false, "解压失败 \(zipPath)")
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        complet?(false, "写入失败 \(zipPath)")
                    }
                }
            }
            task.resume()
        }
    }
    
    private func filePath(name: String) -> String {
        do {
            let documentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/Hybrid_offlinePackage"
            let fileManager = FileManager.default
            try fileManager.createDirectory(atPath: documentPath, withIntermediateDirectories: true, attributes: nil)
            return documentPath + "/" + name
        } catch {
            return ""
        }
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
}
