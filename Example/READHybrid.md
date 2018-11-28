#  企鹅医生Hybrid协议

[init - ( 初始化 )](#init)
[header - ( 导航栏 )](#header)
[forward - (push 页面 )](#forward) 
[modal - (modal 页面 )](#modal) 
[dismiss - (modal 页面 消失)](#dismiss) 
[back - ( 返回上一页 )](#back)
[scroll - ( 页面滚动 ,主要是回弹效果)](#scroll)
[pageshow - ( 页面显示 )](#pageshow)
[pagehide - ( 页面隐藏 )](#pagehide)
[device - ( 获取设备信息 )](#device)
[location - ( 定位 )](#location)
[clipboard - ( 剪贴板 )](#clipboard) 
[storage - ( Storage)](#storage)

<a name="init"></a>
### init

```   请求对象
{
"name":"init",
"params":{
"cache ":true                                                                //离线缓存，默认开启
"callback_name ":"window.hybrid_callbacks "                  //回调方法前缀
}
}
```
<a name="header"></a>
### header
```   请求对象
{
"name":"header",
"params":{
"title":"首页",
"show ":true,
"bigTitle":false,//是否支持大标题
"color":"",//标题颜色
"background ":"#fff",                                        // header 的颜色
"left":[{
"title":"返回",
"callback":"callback_name_1",
"icon":"back.jpg",                                    //图片
"color":"#fff"                                            //按钮字体颜色
}],
"right":[{
"title":"确定",
"callback":"callback_name_1",
"icon":"111.jpg",
"color":"#fff"
}]
}
}
```
<a name="forward"></a>
### forward
```   请求对象
{
"name":"forward",
"params":{
"type":"h5",                                        // h5 或 native 
"url":"/h5",                                        // type 为native 时 native时 url 和业务有关的字符串
"title":"首页",
"animate":true,                                //默认true
"bigTitle":false,//是否是大标题
"color":"",//标题颜色
"background":"",// header 的背景颜色
"fullscreen":false//navagationbar 是否为透明
"fullscreenBackGestures":false //全屏的时候是否需要返回手势
}
}
```
<a name="modal"></a>
### modal
```   请求对象
{
"name":"modal",
"params":{
"type":"h5",                                        // h5 或 native 
"url":"/h5",                                        // type 为native 时 native时 url 和业务有关的字符串
"title":"首页",
"animate":true,                                //默认true
"fullscreen",false    //navagationbar 是否为透明
}
}
```
<a name="dismiss"></a>
### dismiss
```   请求对象
{
"name":"dismiss"
}
```
<a name="back"></a>
### back
```   请求对象
{
"name":"back",
"params":{
"step ":-1                                    // 返回步数默认为 1, -1表示native navigation 最顶层
}
}
```

<a name="scroll"></a>
### scroll
```   请求对象
{
"name":"scroll",
"params":{
"enable":true,
"background":"#eee"
}
}
```

<a name="pageshow"></a>
### pageshow
```   请求对象
{
"name":"pageshow",
"callback":"callback_name " 
}
```
<a name="pagehide"></a>
### pagehide
```   请求对象
{
"name":"pagehide",
"callback":"callback_name" 
}
```
<a name="device"></a>
### device
```   请求对象
{
"name":"device",
"callback":"callback_name" 
}
```
```
{
"version ":"1.0.0"                                    // 容器版本
"os":"ios/10.1"                                        // 系统类型/版本
"dist ":"app store"                                   // 下载渠道
"uuid ":"app store"                                  // 设备 uuid
}
```
<a name="location"></a>
### location
```   请求对象
{
"name":"location",
"params":{
"located":"located_callback ",                                        // 定位成功 回调
"failed":"failed_callback  ",                                            // 失败回调 失败类型 code : 1 - 定位失败 2 - 无权限
"updated":"updated_callback ",                                      //位置更新回调,
"precision":"normal",                                                      // 精度 - normal 普通, high 最高
"timeout":5000                                                                // 默认超时 5秒，超时后执行 failed 回调
}
}
```
<a name="clipboard"></a>
### clipboard
```   请求对象
{
"name":"clipboard",
"params":{
"content ":"复制内容 "                                        //复制内容
}
}
```

<a name="storage"></a>
### storage
```   请求对象
{
"name":"storage",
"params":{
"action ":"set"                                        //只能是：set ，get ，remove  。set代表新增存储，get获取所有的存储，remove移除所有的存储
"hash":{"key":"value"}                            //需要存储的键值对
}
"callback":"fsdfa"
}
```
