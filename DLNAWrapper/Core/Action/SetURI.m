//
//  SetURI.m
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/20.
//  Copyright © 2016年 Key. All rights reserved.
//

#import "SetURI.h"

#define AudioDIDL @"<DIDL-Lite xmlns=\"urn:schemas-upnp-org:metadata-1-0/DIDL-Lite/\" xmlns:dc=\"http://purl.org/dc/elements/1.1/\" xmlns:sec=\"http://www.sec.co.kr/\" xmlns:upnp=\"urn:schemas-upnp-org:metadata-1-0/upnp/\"><item id=\"f-0\" parentID=\"0\" restricted=\"0\"><dc:title>Audio</dc:title><dc:creator>Anonymous</dc:creator><upnp:class>object.item.audioItem</upnp:class><res protocolInfo=\"http-get:*:audio/*:DLNA.ORG_OP=01;DLNA.ORG_CI=0;DLNA.ORG_FLAGS=01700000000000000000000000000000\" sec:URIType=\"public\">%@</res></item></DIDL-Lite>"

#define VideoDIDL @"<DIDL-Lite xmlns=\"urn:schemas-upnp-org:metadata-1-0/DIDL-Lite/\" xmlns:dc=\"http://purl.org/dc/elements/1.1/\" xmlns:sec=\"http://www.sec.co.kr/\" xmlns:upnp=\"urn:schemas-upnp-org:metadata-1-0/upnp/\"><item id=\"f-0\" parentID=\"0\" restricted=\"0\"><dc:title>Video</dc:title><dc:creator>Anonymous</dc:creator><upnp:class>object.item.videoItem</upnp:class><res protocolInfo=\"http-get:*:video/*:DLNA.ORG_OP=01;DLNA.ORG_CI=0;DLNA.ORG_FLAGS=01700000000000000000000000000000\" sec:URIType=\"public\">%@</res></item></DIDL-Lite>"

@interface SetURI ()

@property (nonatomic, strong) NSString *uri;

@property (nonatomic, strong) NSString *metaData;

@property (nonatomic, copy)   void(^successCallback)();

@property (nonatomic, copy)   void(^failureCallback)(NSError *error);

@end

@implementation SetURI

@synthesize uri             = _uri;

@synthesize metaData        = _metaData;

@synthesize successCallback = _successCallback;

@synthesize failureCallback = _failureCallback;

- (instancetype)initWithURI:(NSString *)uri success:(void(^)())successBlock failure:(void(^)(NSError *))failureBlock
{
    self = [self initWithURI:uri metaData:nil success:successBlock failure:failureBlock];
    
    return self;
}

- (instancetype)initWithURI:(NSString *)uri useDefaultAudioMeta:(BOOL)flag success:(void (^)())successBlock failure:(void (^)(NSError *))failureBlock
{
    NSString *metaData = flag ? [NSString stringWithFormat:AudioDIDL, uri] : nil;
    
    self = [self initWithURI:uri metaData:metaData success:successBlock failure:failureBlock];
    
    return self;
}

- (instancetype)initWithURI:(NSString *)uri useDefaultVideoMeta:(BOOL)flag success:(void (^)())successBlock failure:(void (^)(NSError *))failureBlock
{
    NSString *metaData = flag ? [NSString stringWithFormat:VideoDIDL, uri] : nil;
    
    self = [self initWithURI:uri metaData:metaData success:successBlock failure:failureBlock];
    
    return self;
}

- (instancetype)initWithURI:(NSString *)uri metaData:(NSString *)metaData success:(void (^)())successBlock failure:(void (^)(NSError *))failureBlock
{
    self = [self init];
    
    self.uri = uri;
    
    self.metaData = metaData;
    
    self.successCallback = successBlock;
    
    self.failureCallback = failureBlock;
    
    return self;
}

- (NSString *)name
{
    return @"SetAVTransportURI";
}

- (NSString *)soapAction
{
    return [NSString stringWithFormat:@"\"%@#%@\"", SERVICE_TYPE_AVTRANSPORT, [self name]];
}

- (NSData *)postData
{
    GDataXMLElement *setURIElement = [GDataXMLElement elementWithName:@"u:SetAVTransportURI"];
    
    [setURIElement addAttribute:[GDataXMLNode attributeWithName:@"xmlns:u" stringValue:SERVICE_TYPE_AVTRANSPORT]];
    
    GDataXMLElement *instanceIDElement = [GDataXMLElement elementWithName:@"InstanceID" stringValue:@"0"];
    
    GDataXMLElement *currentURIElement = [GDataXMLElement elementWithName:@"CurrentURI" stringValue:self.uri];
    
    GDataXMLElement *currentURIMetaDataElement;
    
    if (self.metaData)
    {
        currentURIMetaDataElement = [GDataXMLElement elementWithName:@"CurrentURIMetaData" stringValue:self.metaData];
    }
    else
    {
        currentURIMetaDataElement = [GDataXMLElement elementWithName:@"CurrentURIMetaData"];
    }
    
    [setURIElement addChild:instanceIDElement];
    
    [setURIElement addChild:currentURIElement];
    
    [setURIElement addChild:currentURIMetaDataElement];
    
    return [super dataXML:setURIElement];
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
