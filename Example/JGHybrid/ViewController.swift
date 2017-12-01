//
//  ViewController.swift
//  JGHybrid
//
//  Created by lbj147123@163.com on 11/03/2017.
//  Copyright (c) 2017 lbj147123@163.com. All rights reserved.
//

import UIKit
import JGHybrid

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        } else {
            // Fallback on earlier versions
        }
    }

    @IBAction func buttonClick(_ sender: Any) {
//        let vc:UIViewController =  MLHybrid.load(urlString: "https://yexiaochai.github.io/Hybrid/webapp/demo/index.html")!
//        let vc:UIViewController =  MLHybrid.load(urlString: "http://web-dev.doctorwork.com/app/health/clinic")!
//        let vc:UIViewController =  MLHybrid.load(urlString: "http://www.iqiyi.com/playlist249635302.htmll")!
        let vc:UIViewController =  MLHybrid.load(urlString: "http://web-dev.doctorwork.com/ios/")!
//        let vc:UIViewController =  MLHybrid.load(urlString: "https://www.baidu.com")!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

