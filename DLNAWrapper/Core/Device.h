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

@property NSString *name;

@property NSString *location;

@property MediaControlService *mediaControlService;

@property RenderingControlService *renderingControlService;

@end
