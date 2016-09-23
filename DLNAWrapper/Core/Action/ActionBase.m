//
//  ActionBase.m
//  DLNAWrapper
//
//  Created by Key.Yao on 16/9/20.
//  Copyright © 2016年 Key. All rights reserved.
//

#import "ActionBase.h"

@implementation ActionBase

- (DDXMLElement *)rootElement
{
    DDXMLElement *root = [[DDXMLElement alloc] initWithName:@"s:Envelope"];
    
    NSMutableArray *rootAttr = [[NSMutableArray alloc] init];
    
    [rootAttr addObject:[DDXMLNode attributeWithName:@"s:encodingStyle" stringValue:@"http://schemas.xmlsoap.org/soap/encoding/"]];
    
    [rootAttr addObject:[DDXMLNode attributeWithName:@"xmlns:s" stringValue:@"http://schemas.xmlsoap.org/soap/envelope/"]];
    
    root.attributes = rootAttr;
    
    return root;
}

- (NSData *)dataXML:(DDXMLElement *)body
{
    DDXMLElement *rootElement = [self rootElement];
    
    DDXMLElement *bodyElement = [[DDXMLElement alloc] initWithName:@"s:Body"];
    
    [bodyElement addChild:body];
    
    [rootElement addChild:bodyElement];
    
    NSString *rootStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"yes\"?>%@%@", [rootElement XMLString], @"\r\n"];
    
    return [rootStr dataUsingEncoding:NSUTF8StringEncoding];
}

@end
