//
//  Device.h
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/19.
//  Copyright © 2016年 Key. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MediaControlService.h"
#import "RenderingControlService.h"

@interface Device : NSObject

@property (nonatomic, strong) NSString                *uuid;

@property (nonatomic, strong) NSString                *name;

@property (nonatomic, strong) NSString                *location;

@property (nonatomic, strong) MediaControlService     *mediaControlService;

@property (nonatomic, strong) RenderingControlService *renderingControlService;

@end
