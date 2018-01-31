//
//  LoadFailedView.swift
//  JGHybrid_Example
//
//  Created by 李保君 on 2018/1/31.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

class LoadFailedView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    class func initWithXib() -> LoadFailedView {
        let view:LoadFailedView = Bundle.main.loadNibNamed("LoadFailedView", owner: nil, options: nil)![0] as! LoadFailedView
        
        return view
    }
    

}
