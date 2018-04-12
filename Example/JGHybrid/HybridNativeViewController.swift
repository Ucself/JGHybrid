//
//  HybridNativeViewController.swift
//  JGHybrid_Example
//
//  Created by 李保君 on 2018/4/11.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import WebKit
import JGHybrid

class HybridNativeViewController: MLHybridViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hybridSetBackgroundColor(UIColor.red)
    }
    
    override func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        //设置
        if let command:MLHybirdCommand = self.parseScriptMessage(message: message),command.name == "header" {
            return
        }
        else {
            super.userContentController(userContentController, didReceive: message)
        }
        
    }
    
}


