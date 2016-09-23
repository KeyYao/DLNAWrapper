//
//  SetVolume.h
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/19.
//  Copyright © 2016年 Key. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActionDelegate.h"
#import "ActionBase.h"

@interface SetVolume : ActionBase <ActionDelegate>

+ (instancetype)initWithVolume:(NSInteger)targetVolume success:(void(^)())successBlock failure:(void(^)(NSError *error))failureBlock;

@end
