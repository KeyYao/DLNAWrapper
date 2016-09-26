//
//  Seek.m
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/19.
//  Copyright © 2016年 Key. All rights reserved.
//

#import "Seek.h"

@interface Seek ()

@property NSString *targetTime;

@property (copy, nonatomic) void(^successCallback)();

@property (copy, nonatomic) void(^failureCallback)(NSError *error);

@end

@implementation Seek

@synthesize targetTime;

@synthesize successCallback;

@synthesize failureCallback;

+ (instancetype)initWithTarget:(NSString *)target success:(void (^)())successBlock failure:(void (^)(NSError *))failureBlock
{
    Seek *seek = [[Seek alloc] init];
    
    seek.targetTime = target;
    
    seek.successCallback = successBlock;
    
    seek.failureCallback = failureBlock;
    
    return seek;
}

- (NSString *)name
{
    return @"Seek";
}

- (NSString *)soapAction
{
    return [NSString stringWithFormat:@"\"%@#%@\"", SERVICE_TYPE_AVTRANSPORT, [self name]];
}

- (NSData *)postData
{
    GDataXMLElement *seekElement = [GDataXMLElement elementWithName:@"u:Seek"];
    
    [seekElement addAttribute:[GDataXMLNode attributeWithName:@"xmlns:u" stringValue:SERVICE_TYPE_AVTRANSPORT]];
    
    GDataXMLElement *instanceIDElement = [GDataXMLElement elementWithName:@"InstanceID" stringValue:@"0"];
    
    GDataXMLElement *unitElement = [GDataXMLElement elementWithName:@"Unit" stringValue:@"REL_TIME"];
    
    GDataXMLElement *targetElement = [GDataXMLElement elementWithName:@"Target" stringValue:targetTime];
    
    [seekElement addChild:instanceIDElement];
    
    [seekElement addChild:unitElement];
    
    [seekElement addChild:targetElement];
    
    return [self dataXML:seekElement];
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
