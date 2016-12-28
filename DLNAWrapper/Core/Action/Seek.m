//
//  Seek.m
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/19.
//  Copyright © 2016年 Key. All rights reserved.
//

#import "Seek.h"

@interface Seek ()

@property (nonatomic, strong) NSString *targetTime;

@property (nonatomic, copy)   void(^successCallback)();

@property (nonatomic, copy)   void(^failureCallback)(NSError *error);

@end

@implementation Seek

@synthesize targetTime      = _targetTime;

@synthesize successCallback = _successCallback;

@synthesize failureCallback = _failureCallback;

- (instancetype)initWithTarget:(NSString *)target success:(void (^)())successBlock failure:(void (^)(NSError *))failureBlock
{
    self = [self init];
    
    self.targetTime = target;
    
    self.successCallback = successBlock;
    
    self.failureCallback = failureBlock;
    
    return self;
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
    
    GDataXMLElement *targetElement = [GDataXMLElement elementWithName:@"Target" stringValue:self.targetTime];
    
    [seekElement addChild:instanceIDElement];
    
    [seekElement addChild:unitElement];
    
    [seekElement addChild:targetElement];
    
    return [self dataXML:seekElement];
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
