//
//  SetURI.m
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/20.
//  Copyright © 2016年 Key. All rights reserved.
//

#import "SetURI.h"

@interface SetURI ()

@property NSString *uri;

@property (copy, nonatomic) void(^successCallback)();

@property (copy, nonatomic) void(^failureCallback)(NSError *error);

@end

@implementation SetURI

@synthesize uri;

@synthesize successCallback;

@synthesize failureCallback;

+ (instancetype)initWithURI:(NSString *)uri success:(void(^)())successBlock failure:(void(^)(NSError *))failureBlock
{
    SetURI *setUri = [[SetURI alloc] init];
    
    setUri.uri = uri;
    
    setUri.successCallback = successBlock;
    
    setUri.failureCallback = failureBlock;
    
    return setUri;
}

- (NSString *)name
{
    return @"SetAVTransportURI";
}

- (NSString *)soapAction
{
    return [NSString stringWithFormat:@"\"%@#%@\"", SERVICE_TYPE_AVTRANSPORT, [self name]];
}

- (NSData *)postData
{
    DDXMLElement *setURIElement = [[DDXMLElement alloc] initWithName:@"u:SetAVTransportURI"];
    
    NSMutableArray<DDXMLNode *> *setURIAttr = [[NSMutableArray alloc] init];
    
    [setURIAttr addObject:[DDXMLNode attributeWithName:@"xmlns:u" stringValue:SERVICE_TYPE_AVTRANSPORT]];
    
    setURIElement.attributes = setURIAttr;
    
    DDXMLElement *instanceIDElement = [[DDXMLElement alloc] initWithName:@"InstanceID" stringValue:@"0"];
    
    DDXMLElement *currentURIElement = [[DDXMLElement alloc] initWithName:@"CurrentURI" stringValue:uri];
    
    DDXMLElement *currentURIMetaDataElement = [[DDXMLElement alloc] initWithName:@"CurrentURIMetaData"];
    
    [setURIElement addChild:instanceIDElement];
    
    [setURIElement addChild:currentURIElement];
    
    [setURIElement addChild:currentURIMetaDataElement];
    
    return [super dataXML:setURIElement];
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
