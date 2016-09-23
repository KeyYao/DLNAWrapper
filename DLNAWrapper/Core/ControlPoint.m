//
//  ControlPoint.m
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/19.
//  Copyright © 2016年 Key. All rights reserved.
//

#import "ControlPoint.h"
#import "AFNetworking.h"

#define IS_SHOW_DEBUG_LOG YES

@implementation ControlPoint

@synthesize service;

+ (instancetype)initWithService:(ControlService *)service
{
    ControlPoint *cp = [[ControlPoint alloc] init];
    
    cp.service = service;
    
    return cp;
}

-(void)executeAction:(id<ActionDelegate>)action
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.requestSerializer = [AFHTTPRequestSerializer new];
    
    [manager.requestSerializer setValue:[action soapAction] forHTTPHeaderField:@"SOAPAction"];
    
    [manager.requestSerializer setValue:@"text/xml;charset=\"utf-8\"" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:self.service.controlURL parameters:nil error:nil];
    
    [request setHTTPBody:[action postData]];
    
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (response != nil) {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            
            NSData *responseData = responseObject;
            
            if ([httpResponse statusCode] == 200) {
                
                if (IS_SHOW_DEBUG_LOG) {
                    
                    NSLog(@"excecute \"%@\" action success, response data -- > %@", [action name], [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [action success:responseData];
                    
                });
                
            } else {
                
                if (IS_SHOW_DEBUG_LOG) {
                    
                    NSLog(@"excecute \"%@\" action error, response data -- > %@", [action name], [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [action failure:error];
                    
                });
                
            }
        } else {
            
            if (IS_SHOW_DEBUG_LOG) {
                
                NSLog(@"excecute \"%@\" action error, no response", [action name]);
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [action failure:error];
                
            });
            
        }
        
    }] resume];
    
}

@end
