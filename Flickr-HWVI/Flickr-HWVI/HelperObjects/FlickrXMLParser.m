//
//  FlickrXMLParser.m
//  Flickr-HWVI
//
//  Created by plt3ch on 5/29/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import "FlickrXMLParser.h"

@interface FlickrXMLParser () <NSXMLParserDelegate>

@property (nonatomic) NSMutableDictionary* currentDictionary;
@property (nonatomic) NSMutableString* curElem;

@end

@implementation FlickrXMLParser

-(instancetype)initWithData:(NSData*)data{
    self = [super init];
    if(self){
        _flickrItems = [NSMutableArray array];
        NSXMLParser* parser = [[NSXMLParser alloc] initWithData:data];
        parser.delegate = self;
        [parser parse];
    }
    
    return self;
}

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"entry"]) {
        self.currentDictionary = [NSMutableDictionary dictionary];
    }
    else if([elementName isEqualToString:@"title"]) {
        self.curElem = [NSMutableString string];
        [self.currentDictionary setValue:self.curElem forKey:@"title"];
    }
    else if([elementName isEqualToString:@"id"]){
        self.curElem = [NSMutableString string];
        [self.currentDictionary setValue:self.curElem forKey:@"flickrEntryId"];
    }
    else if([elementName isEqualToString:@"published"]){
        self.curElem = [NSMutableString string];
    }
    else if([elementName isEqualToString:@"link"] && [[attributeDict objectForKey:@"type"] isEqualToString:@"text/html"]){
        self.curElem = [NSMutableString string];
        [self.currentDictionary setValue:[attributeDict objectForKey:@"href"] forKey:@"flickrAlternativeLink"];
    }
    else if([elementName isEqualToString:@"link"] && [[attributeDict objectForKey:@"type"] isEqualToString:@"image/jpeg"]){
        self.curElem = [NSMutableString string];
        [self.currentDictionary setValue:[attributeDict objectForKey:@"href"] forKey:@"flickrImageLink"];
    }
    else if([elementName isEqualToString:@"name"]){
        self.curElem = [NSMutableString string];
        [self.currentDictionary setValue:self.curElem forKey:@"authorName"];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [self.curElem appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if([elementName isEqualToString:@"entry"]){
        [self.flickrItems addObject:self.currentDictionary];
    }
    else if([elementName isEqualToString:@"published"]){
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
        NSDate* publishedDate = [df dateFromString:self.curElem];
        [self.currentDictionary setValue:publishedDate forKey:@"publishedDate"];
    }

    self.curElem = nil;
}

@end
