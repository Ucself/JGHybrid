//
//  BaseNavigationController.swift
//  DoctorHealth
//
//  Created by 李保君 on 2018/1/9.
//  Copyright © 2018年 doctorworker. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //状态栏权限移交
    override var childForStatusBarStyle: UIViewController? {
        get {
            return self.topViewController
        }
    }
}
