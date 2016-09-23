//
//  Action.h
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/20.
//  Copyright © 2016年 Key. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ActionDelegate <NSObject>

@required

- (NSString *)name;

- (NSString *)soapAction;

- (NSData *)postData;

- (void)success:(NSData *)data;

- (void)failure:(NSError *)error;

@end
