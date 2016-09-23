//
//  ActionBase.h
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/20.
//  Copyright © 2016年 Key. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KissXML/KissXML.h"

#define SERVICE_TYPE_AVTRANSPORT           @"urn:schemas-upnp-org:service:AVTransport:1"
#define SERVICE_TYPE_RENDERING_CONTROL     @"urn:schemas-upnp-org:service:RenderingControl:1"

@interface ActionBase : NSObject

- (DDXMLElement *)rootElement;

- (NSData *)dataXML:(DDXMLElement *)body;

@end
