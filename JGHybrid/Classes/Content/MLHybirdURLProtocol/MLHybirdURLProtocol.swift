//
//  DogHybridURLProtocol.swift
//  Pods
//

import UIKit
import Foundation

class MLHybridURLProtocol: URLProtocol {
    
    override open class func canInit(with request: URLRequest) -> Bool {
        print("MLHybridURLProtocol------------------>canInit")
        return MLHybridURLProtocol.canUseCache(request)
    }

    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        print("MLHybridURLProtocol------------------>canonicalRequest")
        return request
    }

    override open func startLoading() {
        print("MLHybridURLProtocol------------------>startLoading")
        //标记请求  防止重复处理
        let mutableReqeust: NSMutableURLRequest = (self.request as NSURLRequest).mutableCopy() as! NSMutableURLRequest
        URLProtocol.setProperty(true, forKey: Hybrid_constantModel.urlProtocolHandled, in: mutableReqeust)
        if let cachePath = MLHybridURLProtocol.findCache(self.request), let client: URLProtocolClient = self.client {
            let type = cachePath.pathExtension
            let fileData = try? Data(contentsOf: cachePath)
            let response = URLResponse(url: cachePath, mimeType: Hybrid_constantModel.contentTpye[type], expectedContentLength: fileData?.count ?? 0, textEncodingName: "UTF-8")
            client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
            client.urlProtocol(self, didLoad: fileData!)
            client.urlProtocolDidFinishLoading(self)
        }
    }
    
    override open func stopLoading() {
        print("MLHybridURLProtocol------------------>stopLoading")
    }
    
}

extension MLHybridURLProtocol {
    //是否使用缓存文件
    fileprivate class func canUseCache(_ request: URLRequest) -> Bool {
        //是否是有效的URL路径
        guard let requestURL:URL = request.url else { return false }
//        print("canUseCache(_ request: URLRequest) -> requestURL.absoluteString == \(requestURL.absoluteString)")
//        print("canUseCache(_ request: URLRequest) -> requestURL.pathExtension == \(requestURL.pathExtension)")
//        print("canUseCache(_ request: URLRequest) -> requestURL.path == \(requestURL.path)")
//        print("canUseCache(_ request: URLRequest) -> requestURL.lastPathComponent == \(requestURL.lastPathComponent)")
        //查看缓存开关
        let closeSwitch = UserDefaults.standard.bool(forKey: Hybrid_constantModel.switchCache)
        if !closeSwitch {
            return false
        }
        //如果被标记为已处理 直接跳过
        if let hasHandled = URLProtocol.property(forKey: Hybrid_constantModel.urlProtocolHandled, in: request) as? Bool ,
            hasHandled == true {
            return false
        }
        //是否在扩展文件后缀里面
        if !Hybrid_constantModel.types.contains(requestURL.pathExtension) {
            return false
        }
        //是否在需要加载的本地文件里面
        if MLHybrid.shared.mainfestParams.assetsPathExtension.contains(requestURL.lastPathComponent) {
            //文件路径
            let urlFile:URL = MLHybridURLProtocol.getUrlFolder().appendingPathComponent(requestURL.lastPathComponent, isDirectory: false)
            //检测文件是否存在 不存在则异步缓存文件
            if !FileManager.default.fileExists(atPath: urlFile.path) {
                //异步执行下载程序
                DispatchQueue.global().async {
                    let session:URLSession =  URLSession.shared
                    let task:URLSessionTask = session.dataTask(with: requestURL, completionHandler: { (data, response, error) in
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
//                            print("canUseCache(_ request: URLRequest) -> \(catchError)")
                        }
                    })
                    task.resume()
                }
                return false
            }
            return true
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
        print("canUseCache(_ request: URLRequest) -> urlFolder:\(urlFolder)")
        //创建文件夹
        if !FileManager.default.fileExists(atPath: urlFolder.path){
            do {
                try FileManager.default.createDirectory(at: urlFolder, withIntermediateDirectories: true, attributes: nil)
            }
            catch let catchError {
                _ = catchError
//                print("canUseCache(_ request: URLRequest) -> \(catchError)")
            }
        }
        return urlFolder
    }
}
