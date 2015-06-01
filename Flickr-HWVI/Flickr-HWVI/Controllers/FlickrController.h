//
//  FlickrController.h
//  Flickr-HWVI
//
//  Created by plt3ch on 5/29/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "FlickrEntry.h"

@interface FlickrController : NSObject

@property (readonly, strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) FlickrEntry* chosenFlickrEntry;

+(id)sharedInstance;

-(void)downloadFlickrEntriesFromServiceWithCompletionHandler:(void (^)(void)) completion;

-(void)saveContext;

@end
