//
//  RentApartmentsController.h
//  RentApartments-HWV
//
//  Created by plt3ch on 5/19/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UserModel.h"
#import "User.h"
#import "City.h"
#import "ApartamentType.h"
#import "Comment.h"

@interface RentApartmentsController : NSObject

@property (nonatomic, strong) NSMutableArray* apartments;
@property (readonly, strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) NSMutableDictionary* searchCriteria;
@property (nonatomic) User* loggedUser;
@property (nonatomic) Apartment* chosenApartment;

+(id)sharedInstance;

- (void)saveContext;

-(void)loginUser:(User*)user;

-(User*)addUser:(UserModel*)user;
-(bool)isUsernameUnique:(NSString*)username;
-(User*)findUserWithUsername:(NSString*)username AndPassword:(NSString*)password;

-(NSArray*)apartmentTypes;
-(NSArray*)apartmentTypesWithType:(NSString*)type;

-(void)addCityWithUniqueName:(NSString*)name;
-(NSArray*)citiesWithName:(NSString*)name;

-(void)addQuarterWithUniqueName:(NSString*)name AndCity:(City*)city;
-(NSArray*)quartersWithName:(NSString*)name inCity:(City*)city;

-(void)addApartmentWithType:(ApartamentType*)type
                 AndQuarter:(Quarter*)quarter
                   AndPrice:(NSNumber*)price
                AndImageUrl:(NSString*)imageUrl
                ByPublisher:(User*)user
                   withInfo:(NSString*)info;

- (NSFetchedResultsController *)fetchedCommentsResultsControllerForChosenApartment;

-(Comment*)newComment;

@end
