//
//  FlickrXMLParser.h
//  Flickr-HWVI
//
//  Created by plt3ch on 5/29/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrXMLParser : NSObject

@property (nonatomic, strong) NSMutableArray* flickrItems;

-(instancetype)initWithData:(NSData*)data;

@end
