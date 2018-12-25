//
//  DogHybridURLProtocol.swift
//  Pods
//

import UIKit
import Foundation

//更换类名 兼容老版本
typealias MLHybridURLProtocol = HybridURLProtocol

class HybridURLProtocol: URLProtocol {
    
    //是否需要拦截
    override class func canInit(with request: URLRequest) -> Bool {
        print("MLHybridURLProtocol------------------>canInit")
        return MLHybridURLProtocol.canUseCache(request)
    }

    //重定向使用
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        print("MLHybridURLProtocol------------------>canonicalRequest")
        return request
    }

    //拦截开始
    override func startLoading() {
        print("MLHybridURLProtocol------------------>startLoading")
        //标记请求  防止重复处理
        let mutableReqeust: NSMutableURLRequest = (self.request as NSURLRequest).mutableCopy() as! NSMutableURLRequest
        URLProtocol.setProperty(true, forKey: HybridConstantDefineUrlProtocolHandled, in: mutableReqeust)
        if let cachePath = MLHybridURLProtocol.findCache(self.request), let client: URLProtocolClient = self.client {
            let type = cachePath.pathExtension
            let fileData = try? Data(contentsOf: cachePath)
            let response = URLResponse(url: cachePath, mimeType: HybridConstantDefineContentTpye[type], expectedContentLength: fileData?.count ?? 0, textEncodingName: "UTF-8")
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
        //是否是http 或 https
        if let scheme = requestURL.scheme, scheme != "http", scheme != "https" {
            return false
        }
        //如果被标记为已处理 直接跳过
        if let hasHandled = URLProtocol.property(forKey: HybridConstantDefineUrlProtocolHandled, in: request) as? Bool ,
            hasHandled == true {
            return false
        }
        //是否在扩展文件后缀里面
        if !HybridConstantDefineTypes.contains(requestURL.pathExtension) {
            return false
        }
        //检测是否有该文件
        if self.findCache(request) != nil {
            return true
        }
        
        return false
    }
    
    //查找本地文件是否存在
    fileprivate class func findCache(_ request: URLRequest) -> URL? {
        //是否为有效的文件路径
        guard let requestURL:URL = request.url else { return nil }
        //文件路径
        let urlFile:URL = MLHybridURLProtocol.getUrlFolder().appendingPathComponent(requestURL.path, isDirectory: false)
        
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
        //缓存文件夹路径
        let urlFolder:URL = documentURL.appendingPathComponent(HybridConstantDefineOfflinePackageFolder, isDirectory: true)
        return urlFolder
    }
}
