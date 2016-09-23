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
    DDXMLElement *pauseElement = [[DDXMLElement alloc] initWithName:@"u:Pause"];
    
    NSMutableArray<DDXMLNode *> *pauseAttr = [[NSMutableArray alloc] init];
    
    [pauseAttr addObject:[DDXMLNode attributeWithName:@"xmlns:u" stringValue:SERVICE_TYPE_AVTRANSPORT]];
    
    pauseElement.attributes = pauseAttr;
    
    DDXMLElement *instanceIDElement = [[DDXMLElement alloc] initWithName:@"InstanceID" stringValue:@"0"];
    
//    DDXMLElement *speedElement = [[DDXMLElement alloc] initWithName:@"Speed" stringValue:@"1"];
    
    [pauseElement addChild:instanceIDElement];
    
//    [pauseElement addChild:speedElement];
    
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
