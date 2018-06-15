//
//  DogHybridURLProtocol.swift
//  Pods
//

import UIKit
import Foundation

//更换类名 兼容老版本
typealias MLHybridURLProtocol = HybridURLProtocol

class HybridURLProtocol: URLProtocol {
    
    override class func canInit(with request: URLRequest) -> Bool {
        //print("MLHybridURLProtocol------------------>canInit")
        return MLHybridURLProtocol.canUseCache(request)
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        //print("MLHybridURLProtocol------------------>canonicalRequest")
        return request
    }

    override func startLoading() {
        //print("MLHybridURLProtocol------------------>startLoading")
        //标记请求  防止重复处理
        let mutableReqeust: NSMutableURLRequest = (self.request as NSURLRequest).mutableCopy() as! NSMutableURLRequest
        URLProtocol.setProperty(true, forKey: HybridConstantModel.urlProtocolHandled, in: mutableReqeust)
        if let cachePath = MLHybridURLProtocol.findCache(self.request), let client: URLProtocolClient = self.client {
            let type = cachePath.pathExtension
            let fileData = try? Data(contentsOf: cachePath)
            let response = URLResponse(url: cachePath, mimeType: HybridConstantModel.contentTpye[type], expectedContentLength: fileData?.count ?? 0, textEncodingName: "UTF-8")
            client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
            client.urlProtocol(self, didLoad: fileData!)
            client.urlProtocolDidFinishLoading(self)
        }
    }
    
    override func stopLoading() {
        //print("MLHybridURLProtocol------------------>stopLoading")
    }
    
}

extension HybridURLProtocol {
    
    //是否使用缓存文件
    fileprivate class func canUseCache(_ request: URLRequest) -> Bool {
        //是否是有效的URL路径
        guard let requestURL:URL = request.url else { return false }
        //查看缓存开关
        let closeSwitch = UserDefaults.standard.bool(forKey: HybridConstantModel.userDefaultSwitchCache)
        if !closeSwitch {
            return false
        }
        //如果被标记为已处理 直接跳过
        if let hasHandled = URLProtocol.property(forKey: HybridConstantModel.urlProtocolHandled, in: request) as? Bool ,
            hasHandled == true {
            return false
        }
        //是否在扩展文件后缀里面
        if !HybridConstantModel.types.contains(requestURL.pathExtension) {
            return false
        }
        //如果是上次的下载就返回失败
        if requestURL.absoluteString.contains("?hybrid_download=xxx") {
            return false
        }
        
        //是否在需要加载的本地文件里面
        if !MLHybrid.shared.mainfestParams.assetsPathExtension.contains(requestURL.lastPathComponent) {
            return false
        }
        //文件路径
        let urlFile:URL = MLHybridURLProtocol.getUrlFolder().appendingPathComponent(requestURL.lastPathComponent, isDirectory: false)
        //检测文件是否存在 不存在则异步缓存文件
        if FileManager.default.fileExists(atPath: urlFile.path) {
            return true
        }
        //重新拼接下载URL
        let newUrlString:String = requestURL.absoluteString + "?hybrid_download=xxx"
        //是否是有效的URL
        guard let newDownloadURL:URL = URL.init(string: newUrlString) else {
            return false
        }
        //异步执行下载程序
        DispatchQueue.global().async {
            let session:URLSession =  URLSession.shared
            let task:URLSessionTask = session.dataTask(with: newDownloadURL, completionHandler: { (data, response, error) in
                //如果有数据且不为空
                if data == nil || error != nil {
                    return
                }
                //写入文件
                do {
                    try data?.write(to: urlFile)
                }
                catch let catchError {
                    _ = catchError
                }
            })
            //print("下载文件   ->   \(newDownloadURL.absoluteString)")
            task.resume()
        }
        return false
    }
    
    //查找本地文件是否存在
    fileprivate class func findCache(_ request: URLRequest) -> URL? {
        //是否为有效的文件路径
        guard let requestURL:URL = request.url else { return nil }
        //文件路径
        let urlFile:URL = MLHybridURLProtocol.getUrlFolder().appendingPathComponent(requestURL.lastPathComponent, isDirectory: false)
        
        if !FileManager.default.fileExists(atPath: urlFile.path){
            return nil
        }
        else {
            return urlFile
        }
    }
    //返回文件夹路径
    fileprivate class func getUrlFolder() -> URL{
        let documentURL:URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        //获取UUID
        let uuid:String = UIDevice.current.identifierForVendor?.uuidString ?? ""
        //文件夹路径
        let urlFolder:URL = documentURL.appendingPathComponent("\(uuid)_JGHybrid", isDirectory: true)
        //创建文件夹
        if !FileManager.default.fileExists(atPath: urlFolder.path){
            do {
                try FileManager.default.createDirectory(at: urlFolder, withIntermediateDirectories: true, attributes: nil)
            }
            catch let catchError {
                _ = catchError
            }
        }
        return urlFolder
    }
}
