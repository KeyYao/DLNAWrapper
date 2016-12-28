//
//  ControlPoint.h
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/19.
//  Copyright © 2016年 Key. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ControlService.h"
#import "ActionDelegate.h"
#import "Config.h"

@interface ControlPoint : NSObject

- (instancetype)initWithService:(ControlService *)service;

- (void)executeAction:(id<ActionDelegate>)action;

@end
