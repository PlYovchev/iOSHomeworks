//
//  RentApartmentCoreDataController.h
//  RentApartments-HWV
//
//  Created by plt3ch on 5/19/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "User.h"
#import "UserModel.h"
#import "ApartamentType.h"
#import "City.h"
#import "Quarter.h"
#import "Apartment.h"

@interface RentApartmentCoreDataController : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

-(NSArray*)usersWithUsername:(NSString*)username;
-(NSArray*)usersWithUsername:(NSString *)username andPassword:(NSString*)password;
-(User*)addUser:(UserModel*)user;

-(void)addApartmentType:(NSString*)type;
-(NSArray*)apartmentTypesWithType:(NSString*)type;
-(NSArray*)apartmentTypes;

-(void)addCityWithUniqueName:(NSString*)name;
-(NSArray*)citiesWithName:(NSString*)name;
-(NSArray*)cities;

-(void)addQuarterWithUniqueName:(NSString*)name AndCity:(City*)city;
-(NSArray*)quartersWithName:(NSString*)name inCity:(City*)city;
-(NSArray*)quarters;

-(void)addApartmentWithType:(ApartamentType*)type
                 AndQuarter:(Quarter*)quarter
                   AndPrice:(NSNumber*)price
                AndImageUrl:(NSString*)imageUrl
                ByPublisher:(User*)user;
-(NSArray*)apartments;
-(void)deleteApartment:(Apartment*)apartment;

@end
