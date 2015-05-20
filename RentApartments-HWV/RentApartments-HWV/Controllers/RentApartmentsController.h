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

@interface RentApartmentsController : NSObject

@property (nonatomic, strong) NSMutableArray* apartments;
@property (readonly, strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) NSMutableDictionary* searchCriteria;
@property (nonatomic) User* loggedUser;

+(id)sharedInstance;

- (void)saveContext;

-(void)loginUser:(User*)user;

-(User*)addUser:(UserModel*)user;
-(bool)isUsernameUnique:(NSString*)username;
-(User*)findUserWithUsername:(NSString*)username AndPassword:(NSString*)password;

-(NSArray*)apartmentTypes;

@end
