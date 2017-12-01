//
//  MLHybridButton.swift
//  Pods
//

import Foundation
import WebKit

class MLHybridButton: UIButton {
    let margin: CGFloat = 0
    var model: Hybrid_naviButtonModel = Hybrid_naviButtonModel()
    var webView: WKWebView = WKWebView()
    
    class func setUp(models: [Hybrid_naviButtonModel], webView: WKWebView) -> [UIBarButtonItem] {
        let models = models.reversed()

        var items: [UIBarButtonItem] = []
        for model in models {
            let button = MLHybridButton()
            button.model = model
            button.webView = webView
            let titleWidth = model.value.hybridStringWidthWith(15, height: 20) + 2*button.margin
            
            let buttonWidth = titleWidth > 42 ? titleWidth : 42

            button.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: 44)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.setTitleColor(UIColor(red: 0, green: 122/255.0, blue: 255/255.0, alpha: 1), for: .normal)
            if model.icon.count > 0 {
                //button.kf.setImage(with: URL(string: model.icon), for: .normal)
            }
            else if model.tagname.count > 0 {
                print("加载图片 \(Hybrid_constantModel.naviImageHeader + model.tagname)")
                print(UIImage(named: Hybrid_constantModel.naviImageHeader + model.tagname) ?? "未找到对应图片资源")
                button.setImage(UIImage(named: Hybrid_constantModel.naviImageHeader + model.tagname), for: .normal)
            }
            if let _ = UIImage(named: Hybrid_constantModel.naviImageHeader + model.tagname) {
            } else {
                if model.value.count > 0 {
                    button.setTitle(model.value, for: .normal)
                }
            }
            if model.tagname == "back" {
                let image = UIImage(named: MLHybrid.shared.backIndicator)
                button.setImage(image, for: .normal)
                button.contentHorizontalAlignment = .left
            } else {
                button.imageView?.contentMode = .scaleAspectFit
                button.imageEdgeInsets = UIEdgeInsetsMake(0, 13, 0, 13)
            }
            
            if model.value.count > 0 {
                button.setTitle(model.value, for: .normal)
            }

            button.addTarget(button, action: #selector(MLHybridButton.click), for: .touchUpInside)
            items.append(UIBarButtonItem(customView: button))
        }
        return items
    }
    
    
    @objc func click(sender: MLHybridButton) {
        if sender.model.callback.count == 0 {
            var nextResponder = sender.webView.next
            while !(nextResponder is MLHybridViewController) {
                nextResponder = nextResponder?.next ?? MLHybridViewController()
            }
            let vc = nextResponder as? MLHybridViewController
            if let _ = vc?.presentingViewController {
                vc?.dismiss(animated: true, completion: nil)
            } else {
                vc?.navigationController?.popViewController(animated: true)
            }
        }
        let _ = MLHybridTools().callBack(callback: sender.model.callback, webView: sender.webView) { (str) in }
    }

}
