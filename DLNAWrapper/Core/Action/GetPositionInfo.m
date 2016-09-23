//
//  GetPositionInfo.m
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/19.
//  Copyright © 2016年 Key. All rights reserved.
//

#import "GetPositionInfo.h"

@interface GetPositionInfo ()

@property (copy, nonatomic) void(^successCallback)(NSString *currentDuration, NSString *totalDuration);

@property (copy, nonatomic) void(^failureCallback)(NSError *error);

@end

@implementation GetPositionInfo

@synthesize successCallback;

@synthesize failureCallback;

+ (instancetype)initWithSuccess:(void (^)(NSString *, NSString *))successBlock failure:(void (^)(NSError *))failureBlock
{
    GetPositionInfo *getPositionInfo = [[GetPositionInfo alloc] init];
    
    getPositionInfo.successCallback = successBlock;
    
    getPositionInfo.failureCallback = failureBlock;
    
    return getPositionInfo;
}

- (NSString *)name
{
    return @"GetPositionInfo";
}

- (NSString *)soapAction
{
    return [NSString stringWithFormat:@"\"%@#%@\"", SERVICE_TYPE_AVTRANSPORT, [self name]];
}

- (NSData *)postData
{
    DDXMLElement *getPositionInfoElement = [[DDXMLElement alloc] initWithName:@"u:GetPositionInfo"];
    
    NSMutableArray<DDXMLNode *> *getPositionInfoAttr = [[NSMutableArray alloc] init];
    
    [getPositionInfoAttr addObject:[DDXMLNode attributeWithName:@"xmlns:u" stringValue:SERVICE_TYPE_AVTRANSPORT]];
    
    getPositionInfoElement.attributes = getPositionInfoAttr;
    
    DDXMLElement *instanceIDElement = [[DDXMLElement alloc] initWithName:@"InstanceID" stringValue:@"0"];
    
    [getPositionInfoElement addChild:instanceIDElement];
    
    return [self dataXML:getPositionInfoElement];
}

- (void)success:(NSData *)data
{
    DDXMLDocument *document = [[DDXMLDocument alloc] initWithData:data options:0 error:nil];
    
    DDXMLElement *bodyElement = [[document rootElement] elementForName:@"Body" xmlns:[[document rootElement] xmlns]];
    
    DDXMLElement *getPositionInfoResponseElement = [bodyElement elementForName:@"GetPositionInfoResponse" xmlns:SERVICE_TYPE_AVTRANSPORT];
    
    NSString *totalDuration = [[getPositionInfoResponseElement elementForName:@"TrackDuration"] stringValue];
    
    NSString *currentDuration = [[getPositionInfoResponseElement elementForName:@"RelTime"] stringValue];
    
    successCallback(currentDuration, totalDuration);
}

- (void)failure:(NSError *)error
{
    failureCallback(error);
}

@end
