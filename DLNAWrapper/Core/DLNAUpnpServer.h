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

@property NSMutableArray<Device *> *deviceArray;


+ (instancetype)server;

- (void)start;

- (void)search;

@end
