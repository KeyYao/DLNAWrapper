//
//  ControlService.m
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/19.
//  Copyright © 2016年 Key. All rights reserved.
//

#import "ControlService.h"

@implementation ControlService

@synthesize name;
@synthesize type;
@synthesize controlURL;
@synthesize eventSubURL;

- (NSString *)description
{
    return [NSString stringWithFormat:@"name: %@\ntype: %@\ncontrolURL: %@\neventSubURL: %@", name, type, controlURL, eventSubURL];
}

@end
