//
//  GetPositionInfo.m
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/19.
//  Copyright © 2016年 Key. All rights reserved.
//

#import "GetPositionInfo.h"

@interface GetPositionInfo ()

@property (nonatomic, copy) void(^successCallback)(NSString *currentDuration, NSString *totalDuration);

@property (nonatomic, copy) void(^failureCallback)(NSError *error);

@end

@implementation GetPositionInfo

@synthesize successCallback = _successCallback;

@synthesize failureCallback = _failureCallback;

- (instancetype)initWithSuccess:(void (^)(NSString *, NSString *))successBlock failure:(void (^)(NSError *))failureBlock
{
    self = [self init];
    
    self.successCallback = successBlock;
    
    self.failureCallback = failureBlock;
    
    return self;
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
    GDataXMLElement *getPositionInfoElement = [GDataXMLElement elementWithName:@"u:GetPositionInfo"];
    
    [getPositionInfoElement addAttribute:[GDataXMLNode attributeWithName:@"xmlns:u" stringValue:SERVICE_TYPE_AVTRANSPORT]];
    
    GDataXMLElement *instanceIDElement = [GDataXMLElement elementWithName:@"InstanceID" stringValue:@"0"];
    
    [getPositionInfoElement addChild:instanceIDElement];
    
    return [self dataXML:getPositionInfoElement];
}

- (void)success:(NSData *)data
{
    
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
    
    GDataXMLElement *bodyElement = [[[document rootElement] elementsForLocalName:@"Body" URI:[[document rootElement] URI]] objectAtIndex:0];
    
    GDataXMLElement *getPositionInfoResponseElement = [[bodyElement elementsForLocalName:@"GetPositionInfoResponse" URI:SERVICE_TYPE_AVTRANSPORT] objectAtIndex:0];
    
    NSString *totalDuration = [[[getPositionInfoResponseElement elementsForName:@"TrackDuration"] objectAtIndex:0] stringValue];
    
    NSString *currentDuration = [[[getPositionInfoResponseElement elementsForName:@"RelTime"] objectAtIndex:0] stringValue];
    
    self.successCallback(currentDuration, totalDuration);
}

- (void)failure:(NSError *)error
{
    self.failureCallback(error);
}

@end
