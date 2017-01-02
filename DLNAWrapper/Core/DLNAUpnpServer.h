//
//  DLNAUpnpServer.h
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/19.
//  Copyright © 2016年 Key. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncUdpSocket.h"
#import "DeviceChangeDelegate.h"
#import "Device.h"

@interface DLNAUpnpServer : NSObject <GCDAsyncUdpSocketDelegate>

@property (nonatomic, weak) id<DeviceChangeDelegate> delegate;


/**
 获取实例

 @return DLNAUpnpServer instance
 */
+ (instancetype)shareServer;


/**
 启动Upnp服务，默认不搜索设备
 */
- (void)start;


/**
 启动Upnp服务

 @param isSearch 是否立刻搜索设备
 */
- (void)startAndSearch:(BOOL)isSearch;


/**
 搜索局域网内的设备
 */
- (void)search;


/**
 获取已经发现的设备

 @return DMR Array
 */
- (NSArray<Device *> *)getDeviceList;

@end
