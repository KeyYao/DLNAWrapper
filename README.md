# DLNAWrapper

封装DLNA功能，基于Upnp实现简单的视频投射<br>
使用SSDP发现设备<br>
使用SOAP控制设备<br>
封装常用操作（播放，暂停等）<br>
实现了DMC功能<br>
实现投射本地资源功能<br>

引用的依赖库：[GCDAsyncUdpSocket](https://github.com/robbiehanson/CocoaAsyncSocket)、[GDataXML](https://github.com/google/gdata-objectivec-client)、[GCDWebServer](https://github.com/swisspol/GCDWebServer)、[Masonry](https://github.com/SnapKit/Masonry)

## Core
* `DLNAUpnpServer.h` DLNA服务类，用于扫描设备
* `Device.h` 设备
* `DeviceChangeDelegate.h` 设备变化代理
* `ControlPoint.h` 控制点类，用于执行动作
* `ControlService.h` 封装设备可用的控制服务
* `Action` 封装所有操作的动作，详细见Action文件夹
* `Config.h` 定义配置类
* `FileServer.h` 文件服务类，用于投射本地资源，不用此功能可无视

## Using

### 集成到自己的项目中：

#### 1.复制Core文件夹到项目里

* 如果不需要投射本地资源的话，可以不用复制FileServer.h/.m 和 GCDWebServer文件夹，不用配置GCDWebServer和FileServer

#### 2.配置GDataXML

* 项目target -> Build Settings -> Search Paths -> Search Header Paths 添加 "$(SDKROOT)/usr/include/libxml2"
* 项目target -> Build Phases -> Link Binary With Libraries -> 添加 "libxml2.2.tbd"
* 项目target -> Build Phases -> Compile Sources -> 选择GDataXMLNode.m 回车添加 "-fno-objc-arc"

#### 3.配置GCDWebServer

* 项目target -> Build Phases -> Link Binary With Libraries -> 添加 "libz.1.2.5.tbd"

#### 4.配置FileServer

* 项目target -> Build Phases -> Link Binary With Libraries -> 添加 "Photos.framework" 
* ps: 可根据自己需求修改本地资源的获取方式（不用PhotoKit）

#### 5.启动DLNAUpnpServer

```objective-c
[[DLNAUpnpServer server] start];
```

#### 6.启动FileServer（可选）

```objective-c
[[FileServer server] start];
```

#### 对设备的控制操作请参考例子

### 运行例子：

* 根目录下
```bash
pod install
```
* 打开DLNAWrapper.xcworkspace
* ps: 例子写的有点随便，请不要在意
