# DLNAWrapper

封装DLNA投射的基本功能<br>
暂时实现DMC功能<br>

## Using
引用的依赖库：[GCDAsyncUdpSocket](https://github.com/robbiehanson/CocoaAsyncSocket)、[AFNetworking](https://github.com/AFNetworking/AFNetworking)、[Masonry](https://github.com/SnapKit/Masonry)、[KissXML](https://github.com/robbiehanson/KissXML)
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
