# 企鹅医生 Hybrid 协议

######[init - ( 初始化 )](#init) ######[forward - (push 页面 )](#forward) ######[modal - (modal 页面 )](#modal) ######[dismiss - (modal 页面 消失)](#dismiss) ######[back - ( 返回上一页 )](#back) ######[header - ( 导航栏 )](#header) ######[scroll - ( native 回弹效果)](#scroll) ######[pageshow - ( 页面显示 )](#pageshow) ######[pagehide - ( 页面隐藏 )](#pagehide) ######[device - ( 获取设备信息 )](#device) ######[location - ( 定位 )](#location) ######[clipboard - ( 剪贴板 )](#clipboard) ######[storage - ( Storage)](#storage)

<a name="init"></a>

### init

协议 H5 有实现，RN 没有实现的必要；可以不调用，有默认值

```请求对象
{
	"name":"init",
	"params":{
		"cache":true                        //离线缓存，默认开启
		"callback_name":"Hybrid.callback"   //回调方法前缀
	}
}
```

<a name="forward"></a>

### forward

协议 H5 有实现，RN 有实现回调 Hybrid 一个控制器

```请求对象
{
	"name":"forward",
	"params":{
		"type":"h5",                      // h5 或 native
		"url":"/h5",                		 // type 为native 时 native时 url 和业务有关的字符串
		"title":"首页",						 // 页面title
		"animate":true,                   // 默认true
		"color":"",							 // 标题颜色
		"background":"",                  // header的背景颜色
		"fullscreen":false                // navagationbar是否为透明
	}
}
```

<a name="modal"></a>

### modal

协议 H5 有实现，RN 有实现回调 Hybrid 一个控制器

```请求对象
{
	"name":"modal",
	"params":{
		"type":"h5",          // h5 或 native
		"url":"/h5",          // type 为native 时 native时 url 和业务有关的字符串
		"title":"首页",
		"animate":true,       //默认true
		"fullscreen",false    //navagationbar 是否为透明
	}
}
```

<a name="dismiss"></a>

### dismiss

协议 H5 有实现，RN 没有实现的必要

```请求对象
{
	"name":"dismiss"
}
```

<a name="back"></a>

### back

协议 H5 有实现，RN 没有实现的必要

```请求对象
{
	"name":"back",
	"params":{
		"step ":1    // 1:默认, -1:表示native Hybrid最顶层, number:其他数字表示回退几步
	}
}
```

<a name="header"></a>

### header

协议 H5 有实现，RN 没有实现的必要

```请求对象
{
	"name":"header",
	"params":{
		"title":"首页",
		"show ":true,
		"color":"",							//标题颜色
		"background ":"#fff",         	// header 的颜色
		"left":[{
			"title":"返回",
			"callback":"callback_name_1",	//按钮回调事件
			"icon":"back",        			//图片名称，图片放在native
			"color":"#fff"            		//按钮字体颜色
		}],
		"right":[{
			"title":"确定",
			"callback":"callback_name_1",
			"icon":"right",
			"color":"#fff"
		}]
	}
}
```

<a name="scroll"></a>

### scroll

协议 H5 有实现，RN 没有实现的必要

```请求对象
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

协议 H5 有实现，RN 没有实现的必要

```请求对象
{
	"name":"pageshow",
	"callback":"callback_name"
}
```

<a name="pagehide"></a>

### pagehide

协议 H5 有实现，RN 没有实现的必要

```请求对象
{
	"name":"pagehide",
	"callback":"callback_name"
}
```

<a name="device"></a>

### device

协议 H5 有实现（未使用过），RN 有实现

```请求对象
{
	"name":"device",
	"callback":"callback_name" 	//回调ID，RN不需要
}
```

```
{
	"version ":"1.0.0"                 // 容器版本
	"os":"ios/10.1"                    // 系统类型/版本
	"dist ":"app store"                // 下载渠道
	"uuid ":"app store"                // 设备 uuid
}
```

<a name="location"></a>

### location

协议 H5 有实现，RN 有实现，RN 不需要参数

```请求对象
{
	"name":"location",
	"params":{
		"located":"located_callback ",	// 定位成功 回调
		"failed":"failed_callback  ",    	// 失败回调 失败类型 code : 1 - 定位失败 2 - 无权限
		"updated":"updated_callback ",  	// 位置更新回调,
		"precision":"normal",            // 精度 - normal 普通, high 最高
		"timeout":5000                   // 默认超时 5秒，超时后执行 failed 回调
	}
}
```

<a name="storage"></a>

### storage

协议 H5 有实现，RN 有实现

```请求对象
{
	"name":"storage",
	"params":{
		"action ":"set"       	 	//只能是：set ，get ，remove ; set代表新增存储，get获取所有的存储，remove移除所有的存储
		"hash":{"key":"value"}     //需要存储的键值对
	}
	"callback":"fsdfa"
}
```

<a name="clipboard"></a>

### clipboard

协议 H5 有实现，RN 有实现

```请求对象
{
	"name":"clipboard",
	"params":{
		"content ":"复制内容"            //复制内容
	}
}
```
