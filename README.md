# JGHybrid

[![CI Status](http://img.shields.io/travis/lbj147123@163.com/JGHybrid.svg?style=flat)](https://travis-ci.org/lbj147123@163.com/JGHybrid)
[![Version](https://img.shields.io/cocoapods/v/JGHybrid.svg?style=flat)](http://cocoapods.org/pods/JGHybrid)
[![License](https://img.shields.io/cocoapods/l/JGHybrid.svg?style=flat)](http://cocoapods.org/pods/JGHybrid)
[![Platform](https://img.shields.io/cocoapods/p/JGHybrid.svg?style=flat)](http://cocoapods.org/pods/JGHybrid)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

JGHybrid is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

此类库在caiyang基础上新增js注入功能
https://github.com/suncry/MLHybrid

```ruby
pod 'JGHybrid'
```
## How To Use

```
let vc:HybridViewController =  Hybrid.load(urlString: "http://web-qa.doctorwork.com/rapp/health/health-package/0?sku=HS2018002")!
self.navigationController?.pushViewController(vc, animated: true)
```

``` js执行命令
window.webkit.messageHandlers.requestHybrid.postMessage({'name':'updateheader','param':{"left":[{"tagname":"back","callback":""}],"right":[],"title":{"tagname":"title","title":"哈哈哈"}}})
```
## Author

lbj147123@163.com, lbj147123@163.com

## License

JGHybrid is available under the MIT license. See the LICENSE file for more info.
