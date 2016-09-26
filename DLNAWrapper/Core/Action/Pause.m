//
//  Pause.m
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/19.
//  Copyright © 2016年 Key. All rights reserved.
//

#import "Pause.h"

@interface Pause ()

@property (copy, nonatomic) void(^successCallback)();

@property (copy, nonatomic) void(^failureCallback)(NSError *error);

@end

@implementation Pause

@synthesize successCallback;

@synthesize failureCallback;

+ (instancetype)initWithSuccess:(void (^)())successBlock failure:(void (^)(NSError *))failureBlock
{
    Pause *pause = [[Pause alloc] init];
    
    pause.successCallback = successBlock;
    
    pause.failureCallback = failureBlock;
    
    return pause;
}

- (NSString *)name
{
    return @"Pause";
}

- (NSString *)soapAction
{
    return [NSString stringWithFormat:@"\"%@#%@\"", SERVICE_TYPE_AVTRANSPORT, [self name]];
}

- (NSData *)postData
{
    GDataXMLElement *pauseElement = [GDataXMLElement elementWithName:@"u:Pause"];
    
    [pauseElement addAttribute:[GDataXMLNode attributeWithName:@"xmlns:u" stringValue:SERVICE_TYPE_AVTRANSPORT]];
    
    GDataXMLElement *instanceIDElement = [GDataXMLElement elementWithName:@"InstanceID" stringValue:@"0"];
    
    [pauseElement addChild:instanceIDElement];
    
    return [self dataXML:pauseElement];
}

- (void)success:(NSData *)data
{
    successCallback();
}

- (void)failure:(NSError *)error
{
    failureCallback(error);
}

@end
