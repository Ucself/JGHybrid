//
//  Hybrid_headerModel.swift
//  Pods
//

import UIKit

class Hybrid_headerModel: NSObject {
    
    var title: Hybrid_titleModel = Hybrid_titleModel()
    var left: [Hybrid_naviButtonModel] = []
    var right: [Hybrid_naviButtonModel] = []

    class func convert(_ dic: [String: AnyObject]) -> Hybrid_headerModel {
        let headerModel = Hybrid_headerModel()
        headerModel.title = Hybrid_titleModel.convert(dic["title"] as? [String : AnyObject] ?? [:])
        
        var leftArray: [Hybrid_naviButtonModel] = []
        for buttonInfo in (dic["left"] as? [[String : AnyObject]] ?? []) {
            leftArray.append(Hybrid_naviButtonModel.convert(buttonInfo))
        }
        headerModel.left = leftArray
        var rightArray: [Hybrid_naviButtonModel] = []
        for buttonInfo in (dic["right"] as? [[String : AnyObject]] ?? []) {
            rightArray.append(Hybrid_naviButtonModel.convert(buttonInfo))
        }
        headerModel.right = rightArray
        return headerModel
    }

}
