//
//  GetVolume.m
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/19.
//  Copyright © 2016年 Key. All rights reserved.
//

#import "GetVolume.h"

@interface GetVolume ()

@property (nonatomic, copy) void(^successCallback)(NSInteger volume);

@property (nonatomic, copy) void(^failureCallback)(NSError *error);

@end

@implementation GetVolume

@synthesize successCallback = _successCallback;

@synthesize failureCallback = _failureCallback;

- (instancetype)initWithSuccess:(void (^)(NSInteger))successBlock failure:(void (^)(NSError *))failureBlock
{
    self = [self init];
    
    self.successCallback = successBlock;
    
    self.failureCallback = failureBlock;
    
    return self;
}

- (NSString *)name
{
    return @"GetVolume";
}

- (NSString *)soapAction
{
    return [NSString stringWithFormat:@"\"%@#%@\"", SERVICE_TYPE_RENDERING_CONTROL, [self name]];
}

- (NSData *)postData
{
    GDataXMLElement *getVolumeElement = [GDataXMLElement elementWithName:@"u:GetVolume"];
    
    [getVolumeElement addAttribute:[GDataXMLNode attributeWithName:@"xmlns:u" stringValue:SERVICE_TYPE_RENDERING_CONTROL]];
    
    GDataXMLElement *instanceIDElement = [GDataXMLElement elementWithName:@"InstanceID" stringValue:@"0"];
    
    GDataXMLElement *channelElement = [GDataXMLElement elementWithName:@"Channel" stringValue:@"Master"];
    
    [getVolumeElement addChild:instanceIDElement];
    
    [getVolumeElement addChild:channelElement];
    
    return [self dataXML:getVolumeElement];
}

- (void)success:(NSData *)data
{
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
    
    GDataXMLElement *bodyElement = [[[document rootElement] elementsForLocalName:@"Body" URI:[[document rootElement] URI]] objectAtIndex:0];
    
    GDataXMLElement *getVolumeResponseElement = [[bodyElement elementsForLocalName:@"GetVolumeResponse" URI:SERVICE_TYPE_RENDERING_CONTROL] objectAtIndex:0];
    
    NSInteger currentVolume = [[[[getVolumeResponseElement elementsForName:@"CurrentVolume"] objectAtIndex:0] stringValue] integerValue];
    
    self.successCallback(currentVolume);
}

- (void)failure:(NSError *)error
{
    self.failureCallback(error);
}

@end
