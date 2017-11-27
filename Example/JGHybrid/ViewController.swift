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

    @IBAction func buttonClick(_ sender: Any) {
//        let vc:UIViewController =  MLHybrid.load(urlString: "https://yexiaochai.github.io/Hybrid/webapp/demo/index.html")!
//        let vc:UIViewController =  MLHybrid.load(urlString: "http://web-dev.doctorwork.com/app/health/clinic")!
//        let vc:UIViewController =  MLHybrid.load(urlString: "http://www.iqiyi.com/playlist249635302.htmll")!
        let vc:UIViewController =  MLHybrid.load(urlString: "https://ucself.github.io/JGHybrid/gh/")!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

