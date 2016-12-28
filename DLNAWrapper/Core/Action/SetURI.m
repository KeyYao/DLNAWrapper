//
//  SetURI.m
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/20.
//  Copyright © 2016年 Key. All rights reserved.
//

#import "SetURI.h"

@interface SetURI ()

@property (nonatomic, strong) NSString *uri;

@property (nonatomic, copy)   void(^successCallback)();

@property (nonatomic, copy)   void(^failureCallback)(NSError *error);

@end

@implementation SetURI

@synthesize uri             = _uri;

@synthesize successCallback = _successCallback;

@synthesize failureCallback = _failureCallback;

- (instancetype)initWithURI:(NSString *)uri success:(void(^)())successBlock failure:(void(^)(NSError *))failureBlock
{
    self = [self init];
    
    self.uri = uri;
    
    self.successCallback = successBlock;
    
    self.failureCallback = failureBlock;
    
    return self;
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
    GDataXMLElement *setURIElement = [GDataXMLElement elementWithName:@"u:SetAVTransportURI"];
    
    [setURIElement addAttribute:[GDataXMLNode attributeWithName:@"xmlns:u" stringValue:SERVICE_TYPE_AVTRANSPORT]];
    
    GDataXMLElement *instanceIDElement = [GDataXMLElement elementWithName:@"InstanceID" stringValue:@"0"];
    
    GDataXMLElement *currentURIElement = [GDataXMLElement elementWithName:@"CurrentURI" stringValue:self.uri];
    
    GDataXMLElement *currentURIMetaDataElement = [GDataXMLElement elementWithName:@"CurrentURIMetaData"];
    
    [setURIElement addChild:instanceIDElement];
    
    [setURIElement addChild:currentURIElement];
    
    [setURIElement addChild:currentURIMetaDataElement];
    
    return [super dataXML:setURIElement];
}

- (void)success:(NSData *)data
{
    self.successCallback();
}

- (void)failure:(NSError *)error
{
    self.failureCallback(error);
}

@end
