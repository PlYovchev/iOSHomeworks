//
//  FlickrWebConnectionController.m
//  Flickr-HWVI
//
//  Created by plt3ch on 5/29/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import "FlickrWebConnectionController.h"
#import "FlickrXMLParser.h"

#define FLICKR_SERVICE_URL @"https://api.flickr.com/services/feeds/photos_public.gne"

@implementation FlickrWebConnectionController

-(void)downloadFlickrItemsFromServiceWithCompletionHandler:(void (^)(NSArray *array)) completion{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask* getFlickrItemsTask = [session dataTaskWithURL:[NSURL URLWithString:FLICKR_SERVICE_URL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSMutableArray *flickerItems = [NSMutableArray array];
        
        FlickrXMLParser* flickrXMLParser = [[FlickrXMLParser alloc] initWithData:data];
        [flickerItems addObjectsFromArray:flickrXMLParser.flickrItems];
        
        completion(flickerItems);
    }];
    
    [getFlickrItemsTask resume];
}

@end
