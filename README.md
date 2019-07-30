# JGHybrid

[![CI Status](http://img.shields.io/travis/lbj147123@163.com/JGHybrid.svg?style=flat)](https://travis-ci.org/lbj147123@163.com/JGHybrid)
[![Version](https://img.shields.io/cocoapods/v/JGHybrid.svg?style=flat)](http://cocoapods.org/pods/JGHybrid)
[![License](https://img.shields.io/cocoapods/l/JGHybrid.svg?style=flat)](http://cocoapods.org/pods/JGHybrid)
[![Platform](https://img.shields.io/cocoapods/p/JGHybrid.svg?style=flat)](http://cocoapods.org/pods/JGHybrid)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

`JGWebKitURLProtocol`

`JGNavigationBarTransition`

`SSZipArchive`

## Installation

JGHybrid is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```
pod 'JGHybrid'
```

## How To Use

<a href="./R_GlobalConfiguration.md" target="_blank">iOS 全局配置</a>

<a href="./R_iOSAPI.md" target="_blank">iOS API</a>

<a href="./R_H5API.md" target="_blank">H5 API</a>

```
let vc:HybridViewController =  Hybrid.load(urlString: "http://web-qa.doctorwork.com/rapp/health/health-package/0?sku=HS2018002")!
self.navigationController?.pushViewController(vc, animated: true)
```

```js执行命令
window.webkit.messageHandlers.requestHybrid.postMessage({
  name: "updateheader",
  param: {
    left: [{ tagname: "back", callback: "" }],
    right: [],
    title: { tagname: "title", title: "哈哈哈" }
  }
});
```

## Author

ucself ，lbj147123@163.com

## License

JGHybrid is available under the MIT license. See the LICENSE file for more info.
