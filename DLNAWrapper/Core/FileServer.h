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

/**
 获取单例对象
 @return FileService instance
 */
+ (instancetype)shareServer;

/**
 启动文件服务
 */
- (void)start;

/**
 停止文件服务
 */
- (void)stop;

/**
 文件服务器是否在运行
 @return is running
 */
- (BOOL)isRunning;

/**
 根据PHAseet对象获取URL
 @param asset PHAsset
 @return url string
 */
- (NSString *)getUrlFromAsset:(PHAsset *)asset;

/**
 根据文件路径获取URL
 @param path file path
 @return url string
 */
- (NSString *)getUrlFromDocumentPath:(NSString *)path;

@end
