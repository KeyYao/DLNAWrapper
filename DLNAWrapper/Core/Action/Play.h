//
//  Play.h
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/19.
//  Copyright © 2016年 Key. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActionDelegate.h"
#import "ActionBase.h"

@interface Play : ActionBase <ActionDelegate>

- (instancetype)initWithSuccess:(void(^)())successBlock failure:(void(^)(NSError *error))failureBlock;

@end
