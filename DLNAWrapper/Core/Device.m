//
//  Device.m
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/19.
//  Copyright © 2016年 Key. All rights reserved.
//

#import "Device.h"

@implementation Device

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
        
        return [self.location isEqualToString:device.location];
    }
    
    return NO;
}

- (NSUInteger)hash
{
    return [self.location hash];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"name: %@\nlocation: %@\nmediaControl: %@\nrenderingControl: %@", self.name, self.location, self.mediaControlService, self.renderingControlService];
}

@end
