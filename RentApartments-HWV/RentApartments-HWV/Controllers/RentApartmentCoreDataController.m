//
//  RentApartmentCoreDataController.m
//  RentApartments-HWV
//
//  Created by plt3ch on 5/19/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import "RentApartmentCoreDataController.h"

@implementation RentApartmentCoreDataController

#pragma mark - Core Data actions

@synthesize fetchedResultsController = _fetchedResultsController;

-(NSArray*)usersWithUsername:(NSString *)username andPassword:(NSString*)password{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"username = %@ AND password = %@", username, password];
    NSSortDescriptor* sortByQuantity = [NSSortDescriptor
                                        sortDescriptorWithKey:@"username" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortByQuantity];
    NSError *error;
    NSArray *users = [self.managedObjectContext executeFetchRequest:request
                                                              error:&error];
    
    return users;
}

-(NSArray*)usersWithUsername:(NSString*)username{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"username = %@", username];
    NSSortDescriptor* sortByQuantity = [NSSortDescriptor
                                        sortDescriptorWithKey:@"username" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortByQuantity];
    NSError *error;
    NSArray *users = [self.managedObjectContext executeFetchRequest:request
                                                               error:&error];
    
    return users;
}

-(User*)addUser:(UserModel*)user{
    User* newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    newUser.username = user.username;
    newUser.password = user.password;
    newUser.firstname = user.firstname;
    newUser.lastname = user.lastname;
    newUser.address = user.address;
    newUser.age = user.age;
    
    [self saveContext];
    
    return newUser;
}

-(void)addApartmentType:(NSString*)type{
    if([[self apartmentTypesWithType:type] count] == 0){
        ApartamentType* newApartmentType = [NSEntityDescription insertNewObjectForEntityForName:@"ApartamentType"
                                                                         inManagedObjectContext:self.managedObjectContext];
        newApartmentType.type = type;
    
        [self saveContext];
    }
}

-(NSArray*)apartmentTypesWithType:(NSString*)type{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ApartamentType"];
     request.predicate = [NSPredicate predicateWithFormat:@"type = %@", type];
    NSSortDescriptor* sortByQuantity = [NSSortDescriptor
                                        sortDescriptorWithKey:@"type" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortByQuantity];
    NSError *error;
    NSArray *types = [self.managedObjectContext executeFetchRequest:request
                                                              error:&error];
    
    return types;
}

-(NSArray*)apartmentTypes{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ApartamentType"];
    NSSortDescriptor* sortByQuantity = [NSSortDescriptor
                                        sortDescriptorWithKey:@"type" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortByQuantity];
    NSError *error;
    NSArray *types = [self.managedObjectContext executeFetchRequest:request
                                                               error:&error];
    
    return types;
}

-(void)addCityWithUniqueName:(NSString*)name{
    if([[self citiesWithName:name] count] == 0){
        City* newCity = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:self.managedObjectContext];
        newCity.name = name;
    
        [self saveContext];
    }
}

-(NSArray*)citiesWithName:(NSString*)name{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"City"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSSortDescriptor* sortByQuantity = [NSSortDescriptor
                                        sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortByQuantity];
    NSError *error;
    NSArray *cities = [self.managedObjectContext executeFetchRequest:request
                                                                 error:&error];
    
    return cities;
}

-(NSArray*)cities{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"City"];
    NSSortDescriptor* sortByQuantity = [NSSortDescriptor
                                        sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortByQuantity];
    NSError *error;
    NSArray *cities = [self.managedObjectContext executeFetchRequest:request
                                                               error:&error];
    
    return cities;
}

-(void)addQuarterWithUniqueName:(NSString*)name AndCity:(City*)city{
    if([[self quartersWithName:name inCity:city] count] == 0){
        Quarter* newQuarter = [NSEntityDescription insertNewObjectForEntityForName:@"Quarter" inManagedObjectContext:self.managedObjectContext];
        newQuarter.name = name;
        newQuarter.city = city;
    
        [self saveContext];
    }
}

-(NSArray*)quartersWithName:(NSString*)name inCity:(City*)city{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Quarter"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@ AND city.name = %@", name, city.name];
    NSSortDescriptor* sortByQuantity = [NSSortDescriptor
                                        sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortByQuantity];
    NSError *error;
    NSArray *quarters = [self.managedObjectContext executeFetchRequest:request
                                                              error:&error];
    
    return quarters;
}

-(NSArray*)quarters{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Quarter"];
    NSSortDescriptor* sortByQuantity = [NSSortDescriptor
                                        sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortByQuantity];
    NSError *error;
    NSArray *quarters = [self.managedObjectContext executeFetchRequest:request
                                                                 error:&error];
    
    return quarters;
}

-(void)addApartmentWithType:(ApartamentType*)type AndQuarter:(Quarter*)quarter AndPrice:(NSNumber*)price AndImageUrl:(NSString*)imageUrl ByPublisher:(User*)user{
    Apartment* newApartment = [NSEntityDescription insertNewObjectForEntityForName:@"Apartment" inManagedObjectContext:self.managedObjectContext];
    newApartment.apartamentType = type;
    newApartment.quarter = quarter;
    newApartment.price = price;
    newApartment.imagePath = imageUrl;
    newApartment.publisher = user;
    
    [self saveContext];
}

-(NSArray*)apartments{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Apartment"];
    NSSortDescriptor* sortByQuantity = [NSSortDescriptor
                                        sortDescriptorWithKey:@"price" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortByQuantity];
    NSError *error;
    NSArray *apartments = [self.managedObjectContext executeFetchRequest:request
                                                                 error:&error];
    return apartments;
}

-(void)deleteApartment:(Apartment*)apartment{
    [self.managedObjectContext deleteObject:apartment];
    
    [self saveContext];
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Apartment"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"price" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setFetchBatchSize:20];
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context
                                                                      sectionNameKeyPath:nil
                                                                               cacheName:@"Root"];
    [NSFetchedResultsController deleteCacheWithName:nil];
   
    return _fetchedResultsController;
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "PLY.RentApartments_HWV" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"RentApartments_HWV" withExtension:@"momd"];
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
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"RentApartments_HWV.sqlite"];
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


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
