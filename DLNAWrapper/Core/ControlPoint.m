//
//  ControlPoint.m
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/19.
//  Copyright © 2016年 Key. All rights reserved.
//

#import "ControlPoint.h"

@interface ControlPoint ()

@property (nonatomic, strong) ControlService *service;

@end

@implementation ControlPoint

@synthesize service = _service;

- (instancetype)initWithService:(ControlService *)service
{
    self = [self init];
    
    self.service = service;
    
    return self;
}

-(void)executeAction:(id<ActionDelegate>)action
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.service.controlURL]];
    
    request.HTTPMethod = @"POST";
    
    [request addValue:@"text/xml;charset=\"utf-8\"" forHTTPHeaderField:@"Content-Type"];
    
    [request addValue:[action soapAction] forHTTPHeaderField:@"SOAPAction"];
    
    request.HTTPBody = [action postData];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (response != nil) {

            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;

            if ([httpResponse statusCode] == 200) {

                if (IS_DEBUGING) {

                    NSLog(@"===============>> excecute \"%@\" action success, response data -- > %@", [action name], [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);

                }

                dispatch_async(dispatch_get_main_queue(), ^{

                    [action success:data];

                });

            } else {

                if (IS_DEBUGING) {
                    
                    NSLog(@"===============>> excecute \"%@\" action error : \"%@\", response data -- > %@", [action name], error.description, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);

                }

                dispatch_async(dispatch_get_main_queue(), ^{

                    [action failure:error];

                });

            }
        } else {

            if (IS_DEBUGING) {

                NSLog(@"===============>> excecute \"%@\" action error, no response, error: \"%@\"", [action name], error.description);
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [action failure:error];
                
            });
            
        }
        
    }] resume];
    
}

@end
