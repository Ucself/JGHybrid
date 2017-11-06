//
//  Hybrid_titleModel.swift
//  Pods
//

import UIKit

class Hybrid_titleModel: NSObject {
    
    var title: String = ""
    var subtitle: String = ""
    var tagname: String = ""
    var lefticon: String = ""
    var righticon: String = ""
    var placeholder: String = ""
    var callback: String = ""
    var focus: Bool = false
    
    class func convert(_ dic: [String: AnyObject]) -> Hybrid_titleModel {
        let titleModel = Hybrid_titleModel()
        titleModel.title = dic["title"] as? String ?? ""
        titleModel.subtitle = dic["subtitle"] as? String ?? ""
        titleModel.tagname = dic["tagname"] as? String ?? ""
        titleModel.lefticon = dic["lefticon"] as? String ?? ""
        titleModel.righticon = dic["righticon"] as? String ?? ""
        titleModel.placeholder = dic["placeholder"] as? String ?? ""
        titleModel.callback = dic["callback"] as? String ?? ""
        titleModel.focus = dic["focus"] as? Bool ?? false
        return titleModel
    }

}
