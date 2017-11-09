//
//  TestURLProtocol.swift
//  JGHybrid
//
//  Created by 李保君 on 2017/11/9.
//

import UIKit

class TestURLProtocol: URLProtocol {

    override class func canInit(with request: URLRequest) -> Bool {
        
        let `extension`:String? = request.url?.pathExtension
        
        print("`extension`  ======== \(String(describing: `extension`))")
        
        return false
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        print("`canonicalRequest`  ======== \(request.description)")
        return request
    }
    
    override func startLoading() {
        print("`startLoading`  ======== startLoading")
    }
    
    override open func stopLoading() {
        print("`stopLoading`  ======== stopLoading")
    }
}
