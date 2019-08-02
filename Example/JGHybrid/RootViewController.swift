//
//  ViewController.swift
//  JGHybrid
//
//  Created by lbj147123@163.com on 11/03/2017.
//  Copyright (c) 2017 lbj147123@163.com. All rights reserved.
//

import UIKit
import JGHybrid

class RootViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.navigationController?.navigationBar.hybridSetTitleColor(UIColor.black)
//        self.navigationController?.navigationBar.hybridSetBackgroundColor(UIColor.white)
    }
    
    func initUI(){
        self.title = "Hybrid Demo"
        self.jg_navBarBarTintColor = UIColor.white
        self.jg_navBarTitleColor = UIColor.black
        self.jg_navBarBackgroundAlpha = 1.0
    }
    


    @IBAction func buttonClick(_ sender: Any) {
//        let vc:UIViewController =  MLHybrid.load(urlString: "https://yexiaochai.github.io/Hybrid/webapp/demo/index.html")!
//        let vc:UIViewController =  MLHybrid.load(urlString: "http://web-dev.doctorwork.com/app/health/clinic")!
//        let vc:UIViewController =  MLHybrid.load(urlString: "http://www.iqiyi.com/playlist249635302.htmll")!
//        let vc:MLHybridViewController =  MLHybrid.load(urlString: "http://web-dev.doctorwork.com/ios/")!
//        let vc:UIViewController =  MLHybrid.load(urlString: "https://www.baidu.com")!
//        let vc:MLHybridViewController =  MLHybrid.load(urlString: "http://web-dev.doctorwork.com/app/health/member")!
//        vc.isFullScreen = true]
//        let vc:MLHybridViewController =  MLHybrid.load(urlString: "http://web-qa.doctorwork.com/rapp/health/health-package/0?sku=HS2018002")!
        let vc:HybridViewController =  Hybrid.load(urlString: "http://web-dev.doctorwork.com/ios/")!
//        let vc:HybridViewController =  Hybrid.load(urlString: "http://web-qa.doctorwork.com/rapp/health/health-package/0?sku=HS2018002")!
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension RootViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellId:String = "cellId"
        var cell:UITableViewCell!
        if let tempCell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellId) {
            cell = tempCell
        }
        else {
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellId)
        }
        cell.accessoryType = .disclosureIndicator
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Hybrid H5 Demo"
            cell.detailTextLabel?.text = "混合开发点击进入查看H5如何调用实现的协议"
        case 1:
            cell.textLabel?.text = "Hybrid H5 相对路径 Demo"
            cell.detailTextLabel?.text = "混合开发点击进入查看H5如何调用实现的协议"
        default:
            break
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let vc:HybridViewController =  Hybrid.load(urlString: "http://ucself.cn/JGHybrid/gh/")!
            vc.titleName = "Demo首页"
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            //let vc:HybridViewController =  Hybrid.load(urlString: "rapp/festival/index.html")!
            let vc:HybridViewController =  Hybrid.load(urlString: "")!
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
}

