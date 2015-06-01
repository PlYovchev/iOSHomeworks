//
//  FlickrCoreDataController.m
//  Flickr-HWVI
//
//  Created by plt3ch on 5/29/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import "FlickrCoreDataController.h"
#import "FlickrEntry.h"

@implementation FlickrCoreDataController

@synthesize fetchedResultsController = _fetchedResultsController;

-(NSArray*)flickrEntriesWithId:(NSString*)flickrEntryId{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"FlickrEntry"];
    request.predicate = [NSPredicate predicateWithFormat:@"flickrEntryId = %@",flickrEntryId];
    NSSortDescriptor* sortByQuantity = [NSSortDescriptor
                                        sortDescriptorWithKey:@"publishedDate" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortByQuantity];
    NSError *error;
    NSArray *entries = [self.mainManagedObjectContext executeFetchRequest:request
                                                               error:&error];
    
    return entries;
}

-(void)addFlickrEntryWithUniqueId:(NSDictionary*)flickrEntryProperties{
    NSString* flickrEntryId = [flickrEntryProperties objectForKey:@"flickrEntryId"];
    if([[self flickrEntriesWithId:flickrEntryId] count] == 0){
        FlickrEntry* flickrEntry = [NSEntityDescription insertNewObjectForEntityForName:@"FlickrEntry" inManagedObjectContext:self.workerManagedObjectContext];
        [flickrEntry setValuesForKeysWithDictionary:flickrEntryProperties];
        
        [self.workerManagedObjectContext save:nil];
    }
}

-(void)addFlickrEntriesFromArray:(NSArray*)flickrEntries{
    [self.workerManagedObjectContext performBlock:^{
        for (NSDictionary* flickrEntryProp in flickrEntries) {
            [self addFlickrEntryWithUniqueId:flickrEntryProp];
        }
        
        [self.mainManagedObjectContext performBlock:^{
            [self.mainManagedObjectContext save:nil];
            
            [self.parentManagedObjectContext performBlock:^{
                [self saveContext];
            }];
        }];
    }];
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSManagedObjectContext *context = [self mainManagedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FlickrEntry"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"publishedDate" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setFetchBatchSize:20];
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context
                                                                      sectionNameKeyPath:nil
                                                                               cacheName:@"Root"];
    [NSFetchedResultsController deleteCacheWithName:nil];
    
    return _fetchedResultsController;
}

#pragma mark - Core Data stack

@synthesize parentManagedObjectContext = _parentManagedObjectContext;
@synthesize mainManagedObjectContext = _mainManagedObjectContext;
@synthesize workerManagedObjectContext = _workerManagedObjectContext;

@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "PLY.Flickr_HWVI" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Flickr_HWVI" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Flickr_HWVI.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)mainManagedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_mainManagedObjectContext != nil) {
        return _mainManagedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    
    _parentManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_parentManagedObjectContext setPersistentStoreCoordinator:coordinator];
    
    _mainManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_mainManagedObjectContext setParentContext:_parentManagedObjectContext];
    
    _workerManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_workerManagedObjectContext setParentContext:_mainManagedObjectContext];
    
    return _mainManagedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *parentManagedObjectContext = self.parentManagedObjectContext;
    if (parentManagedObjectContext != nil) {
        NSError *error = nil;
        if ([parentManagedObjectContext hasChanges] && ![parentManagedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


@end
