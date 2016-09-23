//
//  Play.m
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/19.
//  Copyright © 2016年 Key. All rights reserved.
//

#import "Play.h"

@interface Play ()

@property (copy, nonatomic) void(^successCallback)();

@property (copy, nonatomic) void(^failureCallback)(NSError *error);

@end

@implementation Play

@synthesize successCallback;

@synthesize failureCallback;

+ (instancetype)initWithSuccess:(void (^)())successBlock failure:(void (^)(NSError *))failureBlock
{
    Play *play = [[Play alloc] init];
    
    play.successCallback = successBlock;
    
    play.failureCallback = failureBlock;
    
    return play;
}

- (NSString *)name
{
    return @"Play";
}

- (NSString *)soapAction
{
    return [NSString stringWithFormat:@"\"%@#%@\"", SERVICE_TYPE_AVTRANSPORT, [self name]];
}

- (NSData *)postData
{
    DDXMLElement *playElement = [[DDXMLElement alloc] initWithName:@"u:Play"];
    
    NSMutableArray<DDXMLNode *> *playAttr = [[NSMutableArray alloc] init];
    
    [playAttr addObject:[DDXMLNode attributeWithName:@"xmlns:u" stringValue:SERVICE_TYPE_AVTRANSPORT]];
    
    playElement.attributes = playAttr;
    
    DDXMLElement *instanceIDElement = [[DDXMLElement alloc] initWithName:@"InstanceID" stringValue:@"0"];
    
    DDXMLElement *speedElement = [[DDXMLElement alloc] initWithName:@"Speed" stringValue:@"1"];
    
    [playElement addChild:instanceIDElement];
    
    [playElement addChild:speedElement];
    
    return [self dataXML:playElement];
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
