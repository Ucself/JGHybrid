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

```ruby
pod 'JGHybrid'
```
## How To Use

```
MLHybrid.register(sess: "GuU7KeV154f8juslkNWRONyVE3m8Sq9h5nJFpcARiCFIvrMsp6boxDzcYabBwAoM",
                  platform: "i",
                  appName: "medlinker",
                  domain: "medlinker.com",
                  backIndicator: "hybridBack",
                  delegate: MethodExtension())
                  
let vc:UIViewController =  MLHybrid.load(urlString: "https://yexiaochai.github.io/Hybrid/webapp/demo/index.html")!
self.navigationController?.pushViewController(vc, animated: true)
```

``` js执行命令
hybird.requestHybrid('updateheader',{"left":[{"tagname":"back","callback":"header_back_1510020527339"}],"right":[],"title":{"tagname":"title","title":"我更新了title"}})
```
## Author

lbj147123@163.com, lbj147123@163.com

## License

JGHybrid is available under the MIT license. See the LICENSE file for more info.
