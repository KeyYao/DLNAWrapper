//
//  ActionBase.m
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/20.
//  Copyright © 2016年 Key. All rights reserved.
//

#import "ActionBase.h"

@implementation ActionBase

- (GDataXMLElement *)rootElement
{
    GDataXMLElement *root = [GDataXMLElement elementWithName:@"s:Envelope"];
    
    [root addAttribute:[GDataXMLNode attributeWithName:@"xmlns:s" stringValue:@"http://schemas.xmlsoap.org/soap/envelope/"]];
    
    [root addAttribute:[GDataXMLNode attributeWithName:@"s:encodingStyle" stringValue:@"http://schemas.xmlsoap.org/soap/encoding/"]];
    
    return root;
}

- (NSData *)dataXML:(GDataXMLElement *)body
{
    GDataXMLElement *rootElement = [self rootElement];
    
    GDataXMLElement *bodyElement = [GDataXMLElement elementWithName:@"s:Body"];
    
    [bodyElement addChild:body];
    
    [rootElement addChild:bodyElement];
    
    NSString *rootStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"yes\"?>%@%@", [rootElement XMLString], @"\r\n"];
    
    return [rootStr dataUsingEncoding:NSUTF8StringEncoding];
}

@end
