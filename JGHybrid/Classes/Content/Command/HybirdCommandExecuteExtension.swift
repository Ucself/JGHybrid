//
//  MLHybridToolsExtension.swift
//  JGHybrid
//
//  Created by 李保君 on 2017/11/24.
//

import UIKit
import WebKit

//新版的Hybrid解析
extension HybirdCommandExecute {
    
    //init - ( 初始化 )
    func hybridInit(){
        guard let params:HybridInitParams = self.command.args.commandParams as? HybridInitParams  else {
            return
        }
        self.command.viewController.hybridEvent = params.callback_name
        UserDefaults.standard.set(params.cache, forKey: HybridConstantModel.userDefaultSwitchCache)
    }
    //forward - (push 页面 )
    func hybridForward(){
        guard let params:HybridForwardParams = self.command.args.commandParams as? HybridForwardParams  else {
            return
        }
        if params.type == "h5" {
            guard let webViewController = MLHybrid.load(urlString: params.url) else {return}
            guard let navi = self.command.viewController.navigationController else {return}
            webViewController.titleName = params.title
            webViewController.needLargeTitle = params.bigTitle  //大标题
            //标题颜色
            if UIColor.hybridColorWithHex(params.color) != .clear {
                webViewController.titleColor = UIColor.hybridColorWithHex(params.color)
            }
            //标题背景
            if UIColor.hybridColorWithHex(params.background) != .clear {
                webViewController.titleBackgroundColor = UIColor.hybridColorWithHex(params.background)
            }
            //如果是全屏，则为透明色
            if params.fullscreen {
                webViewController.isFullScreen = params.fullscreen
            }
            
            navi.pushViewController(webViewController, animated: params.animate)
        } else {
            //native跳转交给外部处理
            command.name = "forwardNative"
            MLHybrid.shared.delegate?.commandExtension(command: command)
        }
    }
    ////modal - (modal 页面)
    func hybridModal(){
        guard let params:HybridModalParams = self.command.args.commandParams as? HybridModalParams  else {
            return
        }
        if params.type == "h5" {
            guard let webViewController = MLHybrid.load(urlString: params.url) else {return}
            webViewController.title = params.title
            //是否全屏
            if params.fullscreen {
                webViewController.isFullScreen = params.fullscreen
            }
            self.command.viewController.present(webViewController, animated: params.animate, completion: nil)
        } else {
            //native跳转交给外部处理
            command.name = "forwardModal"
            MLHybrid.shared.delegate?.commandExtension(command: command)
        }
    }
    
    ////modal - (modal 页面 dismiss)
    func hybridDismiss(){
        self.command.viewController.dismiss(animated: true, completion: nil)
    }
    //back - ( 返回上一页 )
    func hybridBack(){
        guard let params:HybridBackParams = self.command.args.commandParams as? HybridBackParams  else {
            return
        }
        guard let navigationVC = self.command.viewController.navigationController else {
            self.command.viewController.dismiss(animated: true, completion: nil)
            return
        }
        //-1代表跳入根目录
        if params.step == -1 {
            navigationVC.popToRootViewController(animated: true)
            return
        }
        //返回指定步骤
        if let vcs = self.command.viewController.navigationController?.viewControllers {
            if vcs.count > params.step {
                let vc = vcs[vcs.count - params.step - 1]
                let _ = self.command.viewController.navigationController?.popToViewController(vc, animated: true)
                return
            }
        }
    }
    //header - ( 导航栏 )
    func hybridHeader(){
        
        guard let params:HybridHeaderParams = self.command.args.commandParams as? HybridHeaderParams  else {
            return
        }
        guard let vc:MLHybridViewController = self.command.viewController else {
            return
        }
        self.command.viewController.titleName = params.title
        //设置导航栏是否显示
        vc.naviBarHidden = !params.show
        //标题颜色
        if UIColor.hybridColorWithHex(params.color) != .clear {
            self.command.viewController.titleColor = UIColor.hybridColorWithHex(params.color)
        }
        //设置背景色
        if UIColor.hybridColorWithHex(params.background) != .clear {
            //根据16进制获取颜色值
            self.command.viewController.titleBackgroundColor = UIColor.hybridColorWithHex(params.background)
        }
        //设置左边按钮
        if params.left.count != 0 {
            let leftButtonItems:[UIBarButtonItem] = self.hybridHeaderLeftBarButtonItems(params.left)
            self.command.viewController.navigationItem.setLeftBarButtonItems(leftButtonItems, animated: true)
        }
        //设置右边按钮
        if params.right.count != 0 {
            let rightButtonItems:[UIBarButtonItem] = self.hybridHeaderRightBarButtonItems(params.right)
            self.command.viewController.navigationItem.setRightBarButtonItems(rightButtonItems, animated: true)
        }
    }
    //设置按钮
    func hybridHeaderLeftBarButtonItems(_ buttonModels:[HybridHeaderParams.HybridHeaderButtonParams]) -> [UIBarButtonItem] {
        var barButtons:[UIBarButtonItem] = []
        for model:HybridHeaderParams.HybridHeaderButtonParams in buttonModels {
            //需要添加的item
            let barButtonItem:UIBarButtonItem = UIBarButtonItem.init()
            //覆盖一层view
            let coverView:UIView = UIView.init();coverView.backgroundColor = UIColor.clear
            //Button按钮
            let button:hybridHeaderButton = hybridHeaderButton.init()
            
            let titleWidth = model.title.hybridStringWidthWith(15, height: 20)
            let itemWidth = titleWidth > 44 ? titleWidth : 44
            //这是大小
            coverView.frame = CGRect.init(x: 0, y: 0, width: itemWidth, height: 44)
            //设置颜色
            let titleColor:UIColor = UIColor.hybridColorWithHex(model.color)
            if titleColor != .clear {
                button.setTitleColor(titleColor, for: .normal)
            }
            
            //设置标题
            if model.title.count > 0 {
                button.setTitle(model.title, for: .normal)
            }
            //设置图片
            if model.icon != "" ,let buttonIcon:UIImage = UIImage.init(named: MLHybridConfiguration.default.naviImagePrefixes + model.icon){
                button.setImage(buttonIcon, for: .normal)
                coverView.frame = CGRect.init(x: 0, y: 0, width: 44, height: 44)
                button.setTitle("", for: .normal)
            }
            if model.title == "back" {
                let image = UIImage(named: MLHybridConfiguration.default.backIndicator)
                button.setImage(image, for: .normal)
            }
            //添加点击事件
            button.buttonModel = model
            button.addTarget(self, action: #selector(hybridHeaderButtonClick(sender:)), for: .touchUpInside)
            button.frame = coverView.frame
            button.backgroundColor = UIColor.clear
            button.contentHorizontalAlignment = .left
            button.contentVerticalAlignment = .center
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0)
            coverView.addSubview(button)
            //设置View
            barButtonItem.customView = coverView
            //添加到数组
            barButtons.append(barButtonItem)
        }
        
        //        let spaceBar = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        //        spaceBar.width = 6
        //        barButtons.insert(spaceBar, at: 0)
        return barButtons
    }
    //设置按钮
    func hybridHeaderRightBarButtonItems(_ buttonModels:[HybridHeaderParams.HybridHeaderButtonParams]) -> [UIBarButtonItem] {
        var barButtons:[UIBarButtonItem] = []
        for model:HybridHeaderParams.HybridHeaderButtonParams in buttonModels {
            //需要添加的item
            let barButtonItem:UIBarButtonItem = UIBarButtonItem.init()
            //覆盖一层view
            let coverView:UIView = UIView.init();coverView.backgroundColor = UIColor.clear
            //Button按钮
            let button:hybridHeaderButton = hybridHeaderButton.init()
            
            let titleWidth = model.title.hybridStringWidthWith(15, height: 20)
            let itemWidth = titleWidth > 44 ? titleWidth : 44
            //这是大小
            coverView.frame = CGRect.init(x: 0, y: 0, width: itemWidth, height: 44)
            //设置颜色
            let titleColor:UIColor = UIColor.hybridColorWithHex(model.color)
            if titleColor != .clear {
                button.setTitleColor(titleColor, for: .normal)
            }
            
            //设置标题
            if model.title.count > 0 {
                button.setTitle(model.title, for: .normal)
            }
            //设置图片
            if model.icon != "" ,let buttonIcon:UIImage = UIImage.init(named: MLHybridConfiguration.default.naviImagePrefixes + model.icon){
                button.setImage(buttonIcon, for: .normal)
                coverView.frame = CGRect.init(x: 0, y: 0, width: 44, height: 44)
                button.setTitle("", for: .normal)
            }
            if model.title == "back" {
                let image = UIImage(named: MLHybridConfiguration.default.backIndicator)
                button.setImage(image, for: .normal)
            }
            //添加点击事件
            button.buttonModel = model
            button.addTarget(self, action: #selector(hybridHeaderButtonClick(sender:)), for: .touchUpInside)
            //添加到数组
            barButtonItem.customView = coverView
            button.frame = coverView.frame
            button.backgroundColor = UIColor.clear
            button.contentHorizontalAlignment = .right
            button.contentVerticalAlignment = .center
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 6)
            coverView.addSubview(button)
            barButtons.append(barButtonItem)
        }
        
        //        let spaceBar = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        //        spaceBar.width = 6
        //        barButtons.insert(spaceBar, at: 0)
        
        return barButtons
    }
    //给UIButton添加数据
    class hybridHeaderButton: UIButton {
        var buttonModel:HybridHeaderParams.HybridHeaderButtonParams = HybridHeaderParams.HybridHeaderButtonParams()
    }
    
    @objc func hybridHeaderButtonClick(sender: MLHybirdCommandExecute.hybridHeaderButton) {
        self.command.callBack(callback:  sender.buttonModel.callback) { (str) in }
    }
    
    //scroll - ( 页面滚动 ,主要是回弹效果)
    func hybridScroll(){
        guard let params:HybridScrollParams = self.command.args.commandParams as? HybridScrollParams  else {
            return
        }
        self.command.webView.scrollView.bounces = params.enable
        let backgroundColor:UIColor = UIColor.hybridColorWithHex(params.background)
        if backgroundColor != .clear {
            self.command.webView.scrollView.backgroundColor = backgroundColor
        }
    }
    //pageshow - ( 页面显示 )
    func hybridPageshow() {
        self.command.viewController.onShowCallBack = self.command.callbackId
    }
    //pagehide - ( 页面隐藏 )
    func hybridPagehide() {
        self.command.viewController.onHideCallBack = self.command.callbackId
    }
    //device - ( 获取设备信息 )
    func hybridDevice() {
        let deviceInfor:[String:String] = ["version":"",
                                           "os":UIDevice.current.systemName,
                                           "dist":"app store",
                                           "uuid":UUID.init().uuidString]
        self.command.callBack(data: deviceInfor, err_no: 0, msg: "", callback: self.command.callbackId) { (result) in }
    }
    //location - ( 定位 )
    func hybridLocation(){
        guard let params:HybridLocationParams = self.command.args.commandParams as? HybridLocationParams  else {
            return
        }
        self.command.viewController.locationModel.getLocation { (success, errcode, resultData) in
            
            switch errcode {
            case 0:
                //定位成功
                _ = self.command.callBack(data: resultData as AnyObject? ?? "" as AnyObject, err_no: errcode, callback: params.located ,completion: {js in })
            case 1:
                //无权限
                _ = self.command.callBack(data: resultData as AnyObject? ?? "" as AnyObject, err_no: 2, callback: params.failed, completion: {js in })
            case 2:
                //定位失败
                _ = self.command.callBack(data: resultData as AnyObject? ?? "" as AnyObject, err_no: 1, callback: params.failed, completion: {js in })
            default:
                break
            }
        }
    }
    //clipboard - ( 剪贴板 )
    func hybridStorage(){
        guard let params:HybridStorageParams = self.command.args.commandParams as? HybridStorageParams  else {
            return
        }
        //Storage类型
        let action:String = params.action
        //userdefault key
        let userDefaultKey:String = "HybridStorageUserDefaultKey"
        switch action {
        case "set":
            //首先拿出现有的存储
            var newHashDic:[String:String] = [:]
            if let hashDic:[String:String] = UserDefaults.standard.object(forKey: userDefaultKey) as? [String:String] {
                newHashDic = hashDic
                //累加新值
                for (key,value) in params.hashDic {
                    newHashDic[key] = value
                }
            }
            else {
                newHashDic = params.hashDic
            }
            //设置存储
            if newHashDic.count > 0 {
                UserDefaults.standard.set(newHashDic, forKey: userDefaultKey)
            }
        case "get":
            //获取存储
            if let hashDic:[String:String] = UserDefaults.standard.object(forKey: userDefaultKey) as? [String:String] {
                command.callBack(data: hashDic,
                                 err_no: 0,
                                 msg: "",
                                 callback: command.callbackId, completion: { (msg) in })
            }
            else {
                command.callBack(data: [],
                                 err_no: -1,
                                 msg: "No data stored",
                                 callback: command.callbackId, completion: { (msg) in })
            }
            
        case "remove":
            UserDefaults.standard.removeObject(forKey: userDefaultKey)
        default:
            break
        }
    }
    //clipboard - ( 剪贴板 )
    func hybridClipboard(){
        guard let params:HybridClipboardParams = self.command.args.commandParams as? HybridClipboardParams  else {
            return
        }
        UIPasteboard.general.string = params.content
    }
    //MARK: Mainfest 检测
    //离线缓存数据
    func hybridOfflineCacheMainfest(){
        //异步请求
        DispatchQueue.global().async {
            //请求会话
            let session:URLSession = URLSession.shared
            guard let url:URL = URL.init(string: MLHybridConfiguration.default.cacheURLString) else { return }
            let task:URLSessionTask = session.dataTask(with: url) { (data, response, error) in
                //数据文件逻辑判断
                self.hybridOfflineCacheFile(data: data)
            }
            task.resume()
        }
    }
    //离线缓存判断
    func hybridOfflineCacheFile(data:Data?){
        do {
            //旧的ManiFest.json 的 hash
            let oldManifestHash:String? = UserDefaults.standard.string(forKey: HybridConstantModel.userDefaultMainfest)
//            let oldManifestHash:String? = "\(Date.init().timeIntervalSince1970)"          //测试代码
            //获取返回的数据
            guard let responseData = data else { return }
            //返回的data 转换为 字典
            let jsonData = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments)
            guard let manifestDic = jsonData as? [String:AnyObject] else { return }
            //字典转换为对象
            let mainfestParams:HybridMainfestParams = HybridMainfestParams.convert(manifestDic)
            MLHybrid.shared.mainfestParams = mainfestParams     //设置过去方便加载本地使用
            //写入新的数据
            UserDefaults.standard.set(mainfestParams._hash, forKey: HybridConstantModel.userDefaultMainfest)
            //如果manifest没有改变就直接返回
            if oldManifestHash == mainfestParams._hash { return }
            //清空WKWebview 磁盘缓存
            if oldManifestHash != nil
                && oldManifestHash != ""
                && mainfestParams._hash != ""
                && mainfestParams._hash != oldManifestHash {
                //主线程清除缓存
                DispatchQueue.main.sync {
                    if #available(iOS 9.0, *) {
                        WKWebsiteDataStore.default().removeData(ofTypes: [WKWebsiteDataTypeDiskCache], modifiedSince: Date.init(timeIntervalSince1970: 0)) { }
                    } else {
                        // Fallback on earlier versions
                        //之前版本直接删文件
                    }
                }
            }
        }
        catch let catchError {
            print("hybridOfflineCacheMainfest.catchError -> \(catchError)")
        }
        
    }
    
    //MARK: 离线包
    func hybridOfflinePackage(){
        //异步请求
        DispatchQueue.global().async {
            //请求会话
            let session:URLSession = URLSession.shared
            guard let url:URL = URL.init(string: MLHybridConfiguration.default.offlinePackageJsonUrl) else { return }
            let task:URLSessionTask = session.dataTask(with: url) { (data, response, error) in
                //数据文件逻辑判断
                self.hybridOfflineCacheFile(data: data)
            }
            task.resume()
        }
    }
    
    func hybridOfflinePackageJson(data:Data?) {
        do {
            //旧的ManiFest.json 的 hash
            let oldManifestHash:String? = UserDefaults.standard.string(forKey: HybridConstantModel.userDefaultMainfest)
            
            //获取返回的数据
            guard let responseData = data else { return }
            //返回的data 转换为 字典
            let jsonData = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments)
            guard let manifestDic = jsonData as? [String:AnyObject] else { return }
            //字典转换为对象
            let mainfestParams:HybridMainfestParams = HybridMainfestParams.convert(manifestDic)
            MLHybrid.shared.mainfestParams = mainfestParams     //设置过去方便加载本地使用
            //写入新的数据
            UserDefaults.standard.set(mainfestParams._hash, forKey: HybridConstantModel.userDefaultMainfest)
            //如果manifest没有改变就直接返回
            if oldManifestHash == mainfestParams._hash { return }
            //清空WKWebview 磁盘缓存
            if oldManifestHash != nil
                && oldManifestHash != ""
                && mainfestParams._hash != ""
                && mainfestParams._hash != oldManifestHash {
                //主线程清除缓存
                DispatchQueue.main.sync {
                    if #available(iOS 9.0, *) {
                        WKWebsiteDataStore.default().removeData(ofTypes: [WKWebsiteDataTypeDiskCache], modifiedSince: Date.init(timeIntervalSince1970: 0)) { }
                    } else {
                        // Fallback on earlier versions
                        //之前版本直接删文件
                    }
                }
            }
        }
        catch let catchError {
            print("hybridOfflinePackageJson.catchError -> \(catchError)")
        }
    }
}

