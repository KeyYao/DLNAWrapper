//
//  Stop.m
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/19.
//  Copyright © 2016年 Key. All rights reserved.
//

#import "Stop.h"

@interface Stop ()

@property (copy, nonatomic) void(^successCallback)();

@property (copy, nonatomic) void(^failureCallback)(NSError *error);

@end

@implementation Stop

@synthesize successCallback;

@synthesize failureCallback;

+ (instancetype)initWithSuccess:(void (^)())successBlock failure:(void (^)(NSError *))failureBlock
{
    Stop *stop = [[Stop alloc] init];
    
    stop.successCallback = successBlock;
    
    stop.failureCallback = failureBlock;
    
    return stop;
}

- (NSString *)name
{
    return @"Stop";
}

- (NSString *)soapAction
{
    return [NSString stringWithFormat:@"\"%@#%@\"", SERVICE_TYPE_AVTRANSPORT, [self name]];
}

- (NSData *)postData
{
    GDataXMLElement *stopElement = [GDataXMLElement elementWithName:@"u:Stop"];
    
    [stopElement addAttribute:[GDataXMLNode attributeWithName:@"xmlns:u" stringValue:SERVICE_TYPE_AVTRANSPORT]];
    
    GDataXMLElement *instanceIDElement = [GDataXMLElement elementWithName:@"InstanceID" stringValue:@"0"];
    
    [stopElement addChild:instanceIDElement];
    
    return [self dataXML:stopElement];
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
