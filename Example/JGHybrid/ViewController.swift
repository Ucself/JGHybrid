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
        let vc:UIViewController =  MLHybrid.load(urlString: "http://127.0.0.1/webapp/demo/index.html")!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

