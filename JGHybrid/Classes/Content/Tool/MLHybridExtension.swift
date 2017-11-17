//
//  String+MLHybrid.swift
//  Pods
//

import Foundation
extension String{
    
    //MARK:获得string内容高度
    public func hybridStringHeightWith(_ fontSize:CGFloat,width:CGFloat)->CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let size = CGSize(width: width,height: CGFloat.greatestFiniteMagnitude)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping;
        let attributes = [NSAttributedStringKey.font:font, NSAttributedStringKey.paragraphStyle:paragraphStyle.copy()]
//        let attributes = [NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy()]

        let text = self as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: attributes, context:nil)
        let height = Int(rect.size.height) + 1
        return CGFloat(height)
    }
    
    //MARK:获得string内容宽度
    public func hybridStringWidthWith(_ fontSize:CGFloat,height:CGFloat)->CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude,height: height)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping;
        let attributes = [NSAttributedStringKey.font:font, NSAttributedStringKey.paragraphStyle:paragraphStyle.copy()]
//        let attributes = [NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy()]

        let text = self as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: attributes, context:nil)
        let width = Int(rect.size.width) + 1
        return CGFloat(width)
    }

    public func hybridDecodeURLString() -> String {
        let mutStr = NSMutableString(string: self)
        return mutStr.replacingPercentEscapes(using: String.Encoding.utf8.rawValue) ?? ""
    }
    
    public func hybridUrlPathAllowedString() -> String {
        let mutStr = NSMutableString(string: self)
        let tempStr = mutStr.replacingPercentEscapes(using: String.Encoding.utf8.rawValue) ?? ""
        return tempStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed) ?? ""
    }

    public func hybridDecodeJsonStr() -> [String: AnyObject] {
        if let jsonData = self.data(using: String.Encoding.utf8) , self.count > 0 {
            do {
                return try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: AnyObject] ?? ["":"" as AnyObject]
            } catch let error as NSError {
                print("decodeJsonStr == \(error)")
            }
        }
        return [:]
    }
}

extension URL {
    
    /// 获取URL参数字典
    ///
    /// - Returns: URL参数字典
    public func hybridURLParamsDic() -> [String: String] {
        let paramArray = self.query?.components(separatedBy: "&") ?? []
        var paramDic: Dictionary = ["": ""]
        for str in paramArray {
            let tempArray = str.components(separatedBy: "=")
            if tempArray.count == 2 {
                paramDic.updateValue(tempArray[1], forKey: tempArray[0])
            }
        }
        return paramDic
    }

}

extension Dictionary {
    
    /// 字典转JSON字符串
    ///
    /// - Returns: JSON字符串
    public func hybridJSONString() -> String {
        if let jsonData = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted) {
            if let strJson = String(data: jsonData, encoding: .utf8) {
                return strJson
            }
            else {
                return ""
            }
        }
        else {
            return ""
        }
    }
    
}
