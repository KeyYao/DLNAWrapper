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
    GDataXMLElement *playElement = [GDataXMLElement elementWithName:@"u:Play"];
    
    [playElement addAttribute:[GDataXMLNode attributeWithName:@"xmlns:u" stringValue:SERVICE_TYPE_AVTRANSPORT]];
    
    GDataXMLElement *instanceIDElement = [GDataXMLElement elementWithName:@"InstanceID" stringValue:@"0"];
    
    GDataXMLElement *speedElement = [GDataXMLElement elementWithName:@"Speed" stringValue:@"1"];
    
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
