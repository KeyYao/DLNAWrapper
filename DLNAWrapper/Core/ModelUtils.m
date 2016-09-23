//
//  ModelUtils.m
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/23.
//  Copyright © 2016年 Key. All rights reserved.
//

#import "ModelUtils.h"

@implementation ModelUtils

+ (NSString *)timeStringFromInteger:(NSInteger)seconds
{
    NSInteger hours, remainder, minutesm, secs;
    
    hours = seconds / 3600;
    
    remainder = seconds % 3600;
    
    minutesm = remainder / 60;
    
    secs = remainder % 60;
    
    return [NSString stringWithFormat:@"%@:%@:%@",
            (hours < 10 ? [NSString stringWithFormat:@"0%@", [[NSNumber numberWithInteger:hours] stringValue]] : [[NSNumber numberWithInteger:hours] stringValue]),
            (minutesm < 10 ? [NSString stringWithFormat:@"0%@", [[NSNumber numberWithInteger:minutesm] stringValue]] : [[NSNumber numberWithInteger:minutesm] stringValue]),
            (secs < 10 ? [NSString stringWithFormat:@"0%@", [[NSNumber numberWithInteger:secs] stringValue]] : [[NSNumber numberWithInteger:secs] stringValue])];
}

+ (NSInteger)timeIntegerFromString:(NSString *)string
{
    NSArray<NSString *> *split = [string componentsSeparatedByString:@":"];
    
    return ([[split objectAtIndex:0] integerValue] * 3600) + ([[split objectAtIndex:1] integerValue] * 60) + ([[split objectAtIndex:2] integerValue]);
}

@end
