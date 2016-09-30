//
//  FileServer.h
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/26.
//  Copyright © 2016年 Key. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "GCDWebServer.h"


@interface FileServer : NSObject

@property GCDWebServer *webServer;

+ (instancetype)server;

- (void)start;

- (void)stop;

- (NSString *)getUrlFromAsset:(PHAsset *)asset;

@end
