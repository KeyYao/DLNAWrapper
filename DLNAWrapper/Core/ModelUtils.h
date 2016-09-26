//
//  ModelUtils.h
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/23.
//  Copyright © 2016年 Key. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelUtils : NSObject

/**
 * 时间(秒)转String, 格式(xx:xx:xx)
 */
+ (NSString *)timeStringFromInteger:(NSInteger)seconds;

/**
 * 时间(String)转秒, 格式(xx:xx:xx)
 */
+ (NSInteger)timeIntegerFromString:(NSString *)string;

@end
