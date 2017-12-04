//
//  DogHybridURLProtocol.swift
//  Pods
//

import UIKit
import Foundation

class MLHybridURLProtocol: URLProtocol {
    
    override open class func canInit(with request: URLRequest) -> Bool {
        print("MLHybridURLProtocol------------------>canInit")
        self.canUseCache(request)
        return false
        //如果被标记为已处理 直接跳过
        if let hasHandled = URLProtocol.property(forKey: Hybrid_constantModel.urlProtocolHandled, in: request) as? Bool ,
            hasHandled == true {
            return false
        }
        if let _ = self.findCache(request) {
            return true
        }
        return false
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
        if request.url?.host == Hybrid_constantModel.webAppBaseUrl  {
            if let cachePath = MLHybridURLProtocol.findCache(self.request), let client: URLProtocolClient = self.client {
                let url = URL(fileURLWithPath: cachePath)
//                log.debug("读取了本地的 == \(url.path)")
                let type = url.pathExtension
                let fileData = try? Data(contentsOf: URL(fileURLWithPath: cachePath))
                let response = URLResponse(url: url, mimeType: Hybrid_constantModel.contentTpye[type], expectedContentLength: fileData?.count ?? 0, textEncodingName: "UTF-8")
                client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
                client.urlProtocol(self, didLoad: fileData!)
                client.urlProtocolDidFinishLoading(self)
            }
        }
    }
    
    override open func stopLoading() {
        print("MLHybridURLProtocol------------------>stopLoading")
    }
    
}

extension MLHybridURLProtocol {
    //是否使用缓存文件
    fileprivate class func canUseCache(_ request: URLRequest) -> Bool {
        //如果缓存开关关闭
        return false
    }
    
    //查找本地文件是否存在
    fileprivate class func findCache(_ request: URLRequest) -> String? {
        //        let closeSwitch = UserDefaults.standard.bool(forKey: Hybrid_constantModel.switchCache)
        //        if closeSwitch {
        //            print("读取本地资源 关闭")
        //            return nil
        //        }
        if let url = request.url, request.url?.host == Hybrid_constantModel.webAppBaseUrl  {
            if !Hybrid_constantModel.types.contains(url.pathExtension) {
                return nil
            }
            let documentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
            if FileManager.default.fileExists(atPath: documentPath + url.path) {
                return documentPath + url.path
            }
            
        }
        return nil
    }
}
