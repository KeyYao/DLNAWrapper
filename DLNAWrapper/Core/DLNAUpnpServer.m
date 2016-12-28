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

@property (nonatomic, strong) GCDAsyncUdpSocket                         *udpSocket;

@property (nonatomic, strong) NSMutableDictionary<NSString *, Device *> *deviceDic; // key: location string,  value: device

#if OS_OBJECT_USE_OBJC
@property (nonatomic, strong) dispatch_queue_t                          queue;
#else
@property (nonatomic, assign) dispatch_queue_t                          queue;
#endif

@end

@implementation DLNAUpnpServer

@synthesize delegate  = _delegate;

@synthesize deviceDic = _deviceDic;


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
        
        _queue = dispatch_queue_create("moe.key.yao.dlna", DISPATCH_QUEUE_PRIORITY_DEFAULT);
        
        _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        
        _deviceDic = [[NSMutableDictionary alloc] init];
        
    }
    
    return self;
}

- (void)dealloc
{
#if !OS_OBJECT_USE_OBJC
    dispatch_release(_queue);
#endif
}

- (void)start
{
    [_udpSocket bindToPort:UDP_CLIENT_PROT error:nil];
    
    [_udpSocket beginReceiving:nil];
    
    [_udpSocket joinMulticastGroup:UDP_SERVER_HOST error:nil];
    
    [self search];
    
}

- (void)search
{
    if (self.delegate)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.delegate onChange];
            
        });
    }
    
    [_udpSocket sendData:[SEARCH_DATA dataUsingEncoding:NSUTF8StringEncoding] toHost:UDP_SERVER_HOST port:UDP_SERVER_PROT withTimeout:-1 tag:1];
}

- (NSArray *)getDeviceList
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (self.deviceDic)
    {
        [array addObjectsFromArray:self.deviceDic.allValues];
    }
    return array;
}

#pragma mark - private method
- (Device *)parserDeviceLocation:(NSString *)location
{
    dispatch_semaphore_t seamphore = dispatch_semaphore_create(0);
    
    __block Device *device = nil;
    
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
                
                device = [[Device alloc] init];
                
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
                
                dispatch_semaphore_signal(seamphore);
                
            }
        }
        
    }] resume];
    
    dispatch_semaphore_wait(seamphore, DISPATCH_TIME_FOREVER);
    
    return device;
}

- (void)addDevice:(Device *)device forLocation:(NSString *)location
{
    NSLog(@"===============>> add device : %@", location);
    
    [self.deviceDic setObject:device forKey:location];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.delegate)
        {
            [self.delegate onChange];
        }
        
    });
}

- (void)removeDeviceFromLocation:(NSString *)location
{
    NSLog(@"===============>> remove device : %@", location);
    
    [self.deviceDic removeObjectForKey:location];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.delegate)
        {
            [self.delegate onChange];
        }
        
    });
    
}


- (NSString *)headerValueForKey:(NSString *)key inData:(NSString *)data
{
    NSString *str = [NSString stringWithFormat:@"%@", data];
    
    NSRange keyRange = [str rangeOfString:key options:NSCaseInsensitiveSearch];
    
    if (keyRange.location == NSNotFound)
    {
        return @"";
    }
    
    str = [str substringFromIndex:keyRange.location + keyRange.length];
    
    NSRange enterRange = [str rangeOfString:@"\r\n"];
    
    NSString *value = [[str substringToIndex:enterRange.location] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return value;
}

#pragma mark - GCDAsyncUdpSocketDelegate method
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
//    NSString *host;
//    
//    uint16_t port;
//    
//    [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if ([str hasPrefix:@"NOTIFY"])
    {
        // from notify data
        NSString *serviceType = [self headerValueForKey:@"NT:" inData:str];
        
        if ([serviceType isEqualToString:SERVICE_TYPE_AVTRANSPORT])
        {
            NSString *ssdp = [self headerValueForKey:@"NTS:" inData:str];
            
            NSString *location = [self headerValueForKey:@"Location:" inData:str];
            
            if (IS_DEBUGING)
            {
                NSLog(@"===============>> notify data %@\nssdp %@, location %@", str, ssdp, location);
            }
            
            if ([location isEqualToString:@""])
            {
                return;
            }
            
            
            if ([ssdp isEqualToString:@"ssdp:alive"])
            {
                dispatch_async(_queue, ^{
                    
                    if ([self.deviceDic objectForKey:location] == nil)
                    {
                        [self addDevice:[self parserDeviceLocation:location] forLocation:location];
                    }
                    
                });
            }
            else if ([ssdp isEqualToString:@"ssdp:byebye"])
            {
                dispatch_async(_queue, ^{
                    
                    [self removeDeviceFromLocation:location];
                    
                });
            }
        }
        
    }
    else if ([str hasPrefix:@"HTTP/1.1 200 OK"])
    {
        // from search response data
        NSString *location = [self headerValueForKey:@"Location:" inData:str];
        
        if (IS_DEBUGING)
        {
            NSLog(@"===============>> search response data %@", str);
        }
        
        if (![location isEqualToString:@""])
        {
            dispatch_async(_queue, ^{
                
                if ([self.deviceDic objectForKey:location] == nil)
                {
                    [self addDevice:[self parserDeviceLocation:location] forLocation:location];
                }
                
            });
        }
        
    }
    
}


@end
