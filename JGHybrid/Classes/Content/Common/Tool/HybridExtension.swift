//
//  String+MLHybrid.swift
//  Pods
//

import Foundation

extension String{
    
    //获得string内容高度
    public func hybridStringHeightWith(_ fontSize:CGFloat,width:CGFloat)->CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let size = CGSize(width: width,height: CGFloat.greatestFiniteMagnitude)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping;
        let attributes = [NSAttributedString.Key.font:font, NSAttributedString.Key.paragraphStyle:paragraphStyle.copy()]
//        let attributes = [NSAttributedStringKey.font:font, NSAttributedStringKey.paragraphStyle:paragraphStyle.copy()] //swift 4.
//        let attributes = [NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy()]  //swift 3.2
        let text = self as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: attributes, context:nil)
        let height = Int(rect.size.height) + 1
        return CGFloat(height)
    }
    
    //获得string内容宽度
    public func hybridStringWidthWith(_ fontSize:CGFloat,height:CGFloat)->CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude,height: height)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping;
        let attributes = [NSAttributedString.Key.font:font, NSAttributedString.Key.paragraphStyle:paragraphStyle.copy()]
//        let attributes = [NSAttributedStringKey.font:font, NSAttributedStringKey.paragraphStyle:paragraphStyle.copy()]   //swift 4.
//        let attributes = [NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy()] //swift 3.2
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
    
    /// 替换有效的URL
    ///
    /// - Returns: 返回有效的URL
//    public func replaceHost() -> String {
//        guard let scheme:String = URL.init(string: self)?.scheme else {
//            return HybridConfiguration.default.baseHostUrl + self
//        }
//        if (scheme == "http" || scheme == "https") {
//            return self
//        }
//        else {
//            return HybridConfiguration.default.baseHostUrl + self
//        }
//    }
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
extension UIColor {
    //通过十六进制获取颜色
    public class func hybridColorWithHex(_ hex: String, alpha:CGFloat = 1) -> UIColor {
        let hexString = hex.trimmingCharacters(in: .whitespaces).uppercased()
        let nsHexString = hexString.replacingOccurrences(of: "#", with: "") as NSString
        if nsHexString.length == 6 {
            let rString = nsHexString.substring(with: NSMakeRange(0, 2)) as String
            let gString = nsHexString.substring(with: NSMakeRange(2, 2)) as String
            let bString = nsHexString.substring(with: NSMakeRange(4, 2)) as String
            
            var r: UInt32 = 0, g: UInt32 = 0, b: UInt32 = 0
            Scanner(string: rString).scanHexInt32(&r)
            Scanner(string: gString).scanHexInt32(&g)
            Scanner(string: bString).scanHexInt32(&b)
            
            return UIColor(red: CGFloat(r)/CGFloat(UInt8.max),
                           green: CGFloat(g)/CGFloat(UInt8.max),
                           blue: CGFloat(b)/CGFloat(UInt8.max), alpha: alpha)
        }
        return .clear
    }
}

extension UIImage {
    
    public func hybridFilled(withColor color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.setFill()
        guard let context = UIGraphicsGetCurrentContext() else {
            return self
        }
        
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0);
        context.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        guard let mask = self.cgImage else {
            return self
        }
        context.clip(to: rect, mask: mask)
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}

//extension UINavigationBar {
//    //设置背景色
//    public func hybridSetBackgroundColor(_ background:UIColor?) {
//        backgroundColor = background
//        barTintColor = background
//        setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//    }
//    //设置Title颜色
//    public func hybridSetTitleColor(_ text:UIColor){
//        tintColor = text
//        titleTextAttributes = [NSAttributedStringKey.foregroundColor: text, NSAttributedStringKey.font : UIFont.init(name: "PingFangSC-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17)]
//    }
//    //设置全透明
//    public func hybridSetBackgroundClear() {
//        backgroundColor = UIColor.clear
//        barTintColor = UIColor.clear
//        setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        shadowImage = UIImage()
//    }
//}
