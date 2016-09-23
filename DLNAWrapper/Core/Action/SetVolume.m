//
//  SetVolume.m
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/19.
//  Copyright © 2016年 Key. All rights reserved.
//

#import "SetVolume.h"

@interface SetVolume ()

@property NSInteger targetVolume;

@property (copy, nonatomic) void(^successCallback)();

@property (copy, nonatomic) void(^failureCallback)(NSError *error);

@end

@implementation SetVolume

@synthesize targetVolume;

@synthesize successCallback;

@synthesize failureCallback;

+ (instancetype)initWithVolume:(NSInteger)targetVolume success:(void (^)())successBlock failure:(void (^)(NSError *))failureBlock
{
    SetVolume *setVolume = [[SetVolume alloc] init];
    
    setVolume.targetVolume = targetVolume;
    
    setVolume.successCallback = successBlock;
    
    setVolume.failureCallback = failureBlock;
    
    return setVolume;
}

- (NSString *)name
{
    return @"SetVolume";
}

- (NSString *)soapAction
{
    return [NSString stringWithFormat:@"\"%@#%@\"", SERVICE_TYPE_RENDERING_CONTROL, [self name]];
}

- (NSData *)postData
{
    DDXMLElement *setVolumeElement = [[DDXMLElement alloc] initWithName:@"u:SetVolume"];
    
    NSMutableArray<DDXMLNode *> *setVolumeAttr = [[NSMutableArray alloc] init];
    
    [setVolumeAttr addObject:[DDXMLNode attributeWithName:@"xmlns:u" stringValue:@"urn:schemas-upnp-org:service:RenderingControl:1"]];
    
    setVolumeElement.attributes = setVolumeAttr;
    
    DDXMLElement *instanceIDElement = [[DDXMLElement alloc] initWithName:@"InstanceID" stringValue:@"0"];
    
    DDXMLElement *channelElement = [[DDXMLElement alloc] initWithName:@"Channel" stringValue:@"Master"];
    
    DDXMLElement *desiredVolumeElement = [[DDXMLElement alloc] initWithName:@"DesiredVolume" stringValue:[[NSNumber numberWithInteger:targetVolume] stringValue]];
    
    [setVolumeElement addChild:instanceIDElement];
    
    [setVolumeElement addChild:channelElement];
    
    [setVolumeElement addChild:desiredVolumeElement];
    
    return [self dataXML:setVolumeElement];
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
