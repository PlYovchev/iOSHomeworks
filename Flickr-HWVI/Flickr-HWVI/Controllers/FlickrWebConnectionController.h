//
//  FlickrWebConnectionController.h
//  Flickr-HWVI
//
//  Created by plt3ch on 5/29/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrWebConnectionController : NSObject

-(void)downloadFlickrItemsFromServiceWithCompletionHandler:(void (^)(NSArray *array)) completion;

@end
