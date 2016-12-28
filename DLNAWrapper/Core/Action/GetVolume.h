//
//  GetVolume.h
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/19.
//  Copyright © 2016年 Key. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActionDelegate.h"
#import "ActionBase.h"

@interface GetVolume : ActionBase <ActionDelegate>

- (instancetype)initWithSuccess:(void(^)(NSInteger volume))successBlock failure:(void(^)(NSError *error))failureBlock;

@end
