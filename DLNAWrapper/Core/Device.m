//
//  Device.m
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/19.
//  Copyright © 2016年 Key. All rights reserved.
//

#import "Device.h"

@implementation Device

@synthesize uuid                    = _uuid;

@synthesize name                    = _name;

@synthesize location                = _location;

@synthesize mediaControlService     = _mediaControlService;

@synthesize renderingControlService = _renderingControlService;

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    }
    
    if (other != nil && [other isMemberOfClass:Device.class]) {
        
        Device *device = (Device *)other;
        
        return [self.uuid isEqualToString:device.uuid];
    }
    
    return NO;
}

- (NSUInteger)hash
{
    return [self.uuid hash];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"name: %@\nlocation: %@\nuuid: %@\nmediaControl: %@\nrenderingControl: %@", self.name, self.location, self.uuid, self.mediaControlService, self.renderingControlService];
}

@end
