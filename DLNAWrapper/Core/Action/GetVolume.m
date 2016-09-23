//
//  GetVolume.m
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/19.
//  Copyright © 2016年 Key. All rights reserved.
//

#import "GetVolume.h"

@interface GetVolume ()

@property (copy, nonatomic) void(^successCallback)(NSInteger volume);

@property (copy, nonatomic) void(^failureCallback)(NSError *error);

@end

@implementation GetVolume

@synthesize successCallback;

@synthesize failureCallback;

+ (instancetype)initWithSuccess:(void (^)(NSInteger))successBlock failure:(void (^)(NSError *))failureBlock
{
    GetVolume *getVolumne = [[GetVolume alloc] init];
    
    getVolumne.successCallback = successBlock;
    
    getVolumne.failureCallback = failureBlock;
    
    return getVolumne;
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
    DDXMLElement *getVolumeElement = [[DDXMLElement alloc] initWithName:@"u:GetVolume"];
    
    NSMutableArray<DDXMLNode *> *getVolumeAttr = [[NSMutableArray alloc] init];
    
    [getVolumeAttr addObject:[DDXMLNode attributeWithName:@"xmlns:u" stringValue:SERVICE_TYPE_RENDERING_CONTROL]];
    
    getVolumeElement.attributes = getVolumeAttr;
    
    DDXMLElement *instanceIDElement = [[DDXMLElement alloc] initWithName:@"InstanceID" stringValue:@"0"];
    
    DDXMLElement *channelElement = [[DDXMLElement alloc] initWithName:@"Channel" stringValue:@"Master"];
    
    [getVolumeElement addChild:instanceIDElement];
    
    [getVolumeElement addChild:channelElement];
    
    return [self dataXML:getVolumeElement];
}

- (void)success:(NSData *)data
{
    DDXMLDocument *document = [[DDXMLDocument alloc] initWithData:data options:0 error:nil];
    
    DDXMLElement *bodyElement = [[document rootElement] elementForName:@"Body" xmlns:[[document rootElement] xmlns]];
    
    DDXMLElement *getVolumeResponseElement = [bodyElement elementForName:@"u:GetVolumeResponse" xmlns:SERVICE_TYPE_RENDERING_CONTROL];
    
    NSInteger currentVolume = [[[getVolumeResponseElement elementForName:@"CurrentVolume"] stringValue] integerValue];
    
    successCallback(currentVolume);
}

- (void)failure:(NSError *)error
{
    failureCallback(error);
}

@end
