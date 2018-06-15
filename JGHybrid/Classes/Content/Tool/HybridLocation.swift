//
//  MLHybridLocation.swift
//  Pods
//

import UIKit
import CoreLocation

//更换类名 兼容老版本
typealias MLHybridLocation = HybridLocation

class HybridLocation: NSObject, CLLocationManagerDelegate {
    //定位管理器
    let locationManager:CLLocationManager = CLLocationManager()
    //* errcode错误码：
    //0、无错误；
    //1、“Permission denied” - 用户不允许地理定位；
    //2、“Position unavailable” - 无法获取当前位置、
    //3、“Timeout” - 操作超时、
    //4、“No support” - 不支持
    var finishBlock: ((_ success: Bool, _ errcode: Int, _ resultData: [String: AnyObject]?) -> ())?
    //获取当前位置调用
    func getLocation(_ finishBlock: @escaping ((_ success: Bool, _ errcode: Int, _ resultData: [String: AnyObject]?) -> ())) {
        self.finishBlock = finishBlock
        //设置定位服务管理器代理
        locationManager.delegate = self
        //设置定位进度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //更新距离
        locationManager.distanceFilter = 100
        //检测是否支持定位
        if !self.isLocationPermission() {
            self.finishBlock?(false, 1, nil)
        }
        //发送授权申请
        locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func stopUpdateLocation() {
        locationManager.stopUpdatingLocation()
    }
    //检测是否支持定位
    func isLocationPermission () -> Bool {
        if !CLLocationManager.locationServicesEnabled() { //不支持定位服务
            return false
        }
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            return true
        } else {
            return false
        }
    }
    //MARK:CLLocationManagerDelegate
    //定位改变执行，可以得到新位置、旧位置
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //获取最新的坐标
        if let currLocation:CLLocation = locations.last {
            let data = ["coordate": ["long": "\(currLocation.coordinate.longitude)", "lat": "\(currLocation.coordinate.latitude)"]]
            self.finishBlock?(true, 0, data as [String : AnyObject]?)
             self.finishBlock = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.finishBlock?(false, 2, nil)
        self.finishBlock = nil
    }
}
