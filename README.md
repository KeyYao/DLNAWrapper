# DLNAWrapper

封装DLNA功能，基于Upnp实现简单的视频投射（暂时支持网络视频）<br>
使用SSDP发现设备<br>
使用SOAP控制设备<br>
封装常用操作（播放，暂停等）<br>
暂时只实现了DMC功能<br>

## Using

引用的依赖库：[GCDAsyncUdpSocket](https://github.com/robbiehanson/CocoaAsyncSocket)、[GDataXML](https://github.com/google/gdata-objectivec-client)、[Masonry](https://github.com/SnapKit/Masonry)

### 配置GDataXML
* 项目target -> Build Settings -> Search Paths -> Search Header Paths 添加 "$(SDKROOT)/usr/include/libxml2"
* 项目target -> Build Phases -> Link Binary With Libraries -> 添加 "libxml2.2.tbd"
* 项目target -> Build Phases -> Compile Sources -> 选择GDataXMLNode.m 回车添加 "-fno-objc-arc"

### 配置pod

* 根目录下
```bash
pod install
```

## Core
* `DLNAUpnpServer.h`
DLNA服务类，用于扫描设备
* `Device.h`
设备
* `DeviceChangeDelegate.h`
设备变化代理
* `ControlPoint.h`
控制点类，用于执行动作
* `ControlService.h` 封装设备可用的控制服务
* `Action` 封装所有操作的动作，详细见Action文件夹
