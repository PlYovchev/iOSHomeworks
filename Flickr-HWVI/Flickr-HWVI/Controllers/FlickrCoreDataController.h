//
//  FlickrCoreDataController.h
//  Flickr-HWVI
//
//  Created by plt3ch on 5/29/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface FlickrCoreDataController : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *parentManagedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *mainManagedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *workerManagedObjectContext;

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

-(NSArray*)flickrEntriesWithId:(NSString*)flickrEntryId;
-(void)addFlickrEntryWithUniqueId:(NSDictionary*)flickrEntryProperties;
-(void)addFlickrEntriesFromArray:(NSArray*)flickrEntries;

@end
