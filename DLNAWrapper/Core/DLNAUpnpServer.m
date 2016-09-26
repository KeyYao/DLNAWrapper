//
//  DLNAUpnpServer.m
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/19.
//  Copyright © 2016年 Key. All rights reserved.
//

#import "DLNAUpnpServer.h"
#import "GDataXMLNode.h"

#import "Config.h"
#import "MediaControlService.h"
#import "RenderingControlService.h"

@interface DLNAUpnpServer ()

@property GCDAsyncUdpSocket *udpSocket;

@end

@implementation DLNAUpnpServer

@synthesize delegate;

@synthesize udpSocket;

@synthesize deviceArray;


+ (instancetype)server
{
    static DLNAUpnpServer *server;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        server = [[self alloc] init];
        
    });
    
    return server;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        
        deviceArray = [[NSMutableArray alloc] init];
        
    }
    
    return self;
}

- (void)start
{
    [udpSocket bindToPort:CLIENT_PROT error:nil];
    
    [udpSocket beginReceiving:nil];
    
    [udpSocket joinMulticastGroup:SERVER_HOST error:nil];
    
    [self search];
}

- (void)search
{
    [self.deviceArray removeAllObjects];
    
    if (self.delegate != nil) {
        
        [delegate onChange];
        
    }
    
    [udpSocket sendData:[SEARCH_DATA dataUsingEncoding:NSUTF8StringEncoding] toHost:SERVER_HOST port:SERVER_PROT withTimeout:-1 tag:1];
}

- (void)parserDeviceLocation:(NSString *)location
{
    NSRange protocolRange = [location rangeOfString:@"http://" options:NSCaseInsensitiveSearch];
    
    NSString *locationWithoutProtocolStr = [location substringFromIndex:protocolRange.length];
    
    NSRange addressRange = [locationWithoutProtocolStr rangeOfString:@"/"];
    
    NSString *address = [[NSString alloc] initWithFormat:@"http://%@", [locationWithoutProtocolStr substringToIndex:addressRange.location]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:location]];
    
    request.HTTPMethod = @"GET";
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        if (response != nil) {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            
            if ([httpResponse statusCode] == 200) {
                
                Device *device = [[Device alloc] init];
                
                device.location = location;
                
                GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
                
                GDataXMLElement *deviceElement = [[[document rootElement] elementsForName:@"device"] objectAtIndex:0];
                
                NSString *deviceName = [[[deviceElement elementsForName:@"friendlyName"] objectAtIndex:0] stringValue];
                
                device.name = deviceName;
                
                GDataXMLElement *serviceListElement = [[deviceElement elementsForName:@"serviceList"] objectAtIndex:0];
                
                NSArray<GDataXMLElement *> *serviceElementArray = [serviceListElement elementsForName:@"service"];
                
                for (GDataXMLElement *serviceElement in serviceElementArray) {
                    
                    NSString *serviceId = [[[serviceElement elementsForName:@"serviceId"] objectAtIndex:0] stringValue];
        
                    if ([serviceId containsString:MEDIA_CONTROL_SERVICE_ID]) {
        
                        MediaControlService *service = [[MediaControlService alloc] init];
        
                        service.type = [[[serviceElement elementsForName:@"serviceType"] objectAtIndex:0] stringValue];
        
                        NSString *format;
        
                        NSString *controlUrl = [[[serviceElement elementsForName:@"controlURL"] objectAtIndex:0] stringValue];
        
                        if (![controlUrl hasPrefix:@"/"]) {
        
                            format = @"%@/%@";
        
                        } else {
        
                            format = @"%@%@";
        
                        }
        
                        service.controlURL = [NSString stringWithFormat:format, address, controlUrl];
        
                        NSString *eventSubUrl = [[[serviceElement elementsForName:@"eventSubURL"] objectAtIndex:0] stringValue];
        
                        if (![eventSubUrl hasPrefix:@"/"]) {
        
                            format = @"%@/%@";
        
                        } else {
        
                            format = @"%@%@";
        
                        }
        
                        service.eventSubURL = [NSString stringWithFormat:format, address, eventSubUrl];
        
                        device.mediaControlService = service;
        
                        continue;
                    }
        
                    if ([serviceId containsString:RENDERING_CONTROL_SERVICE_ID]) {
        
                        RenderingControlService *service = [[RenderingControlService alloc] init];
        
                        service.type = [[[serviceElement elementsForName:@"serviceType"] objectAtIndex:0] stringValue];
        
                        NSString *format;
        
                        NSString *controlUrl = [[[serviceElement elementsForName:@"controlURL"] objectAtIndex:0] stringValue];
        
                        if (![controlUrl hasPrefix:@"/"]) {
        
                            format = @"%@/%@";
                            
                        } else {
                            
                            format = @"%@%@";
                            
                        }
                        
                        service.controlURL = [NSString stringWithFormat:format, address, controlUrl];
                        
                        NSString *eventSubUrl = [[[serviceElement elementsForName:@"eventSubURL"] objectAtIndex:0] stringValue];
                        
                        if (![eventSubUrl hasPrefix:@"/"]) {
                            
                            format = @"%@/%@";
                            
                        } else {
                            
                            format = @"%@%@";
                            
                        }
                        
                        service.eventSubURL = [NSString stringWithFormat:format, address, eventSubUrl];
                        
                        device.renderingControlService = service;
                        
                        continue;
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self addDevice:device];
                    
                });
                
            }
        }
        
    }] resume];
    
}

- (void)addDevice:(Device *)device
{
    if (![deviceArray containsObject:device]) {
        
        if (IS_DEBUGING) {
            
            NSLog(@"device -- > %@", device);
            
        }
        
        [deviceArray addObject:device];
        
        if (self.delegate != nil) {
            
            [delegate onChange];
            
        }
    }
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
//    NSString *host;
//    
//    uint16_t port;
//    
//    [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    if (IS_DEBUGING) {
        
        NSLog(@"receiver data %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
    }
    
    NSRange locationRange = [str rangeOfString:@"Location:" options:NSCaseInsensitiveSearch];
    
    if (locationRange.location == NSNotFound) {
        return;
    }
    
    str = [str substringFromIndex:locationRange.location + locationRange.length];
    
    NSRange enterRange = [str rangeOfString:@"\r\n"];
    
    NSString *location = [[str substringToIndex:enterRange.location] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [self parserDeviceLocation:location];
}


@end
