//
//  SetURI.h
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/20.
//  Copyright © 2016年 Key. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActionDelegate.h"
#import "ActionBase.h"

@interface SetURI : ActionBase <ActionDelegate>

- (instancetype)initWithURI:(NSString *)uri success:(void(^)())successBlock failure:(void(^)(NSError *error))failureBlock;

- (instancetype)initWithURI:(NSString *)uri metaData:(NSString *)metaData success:(void(^)())successBlock failure:(void(^)(NSError *error))failureBlock;

@end
