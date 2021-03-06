//
//  RentApartmentsController.m
//  RentApartments-HWV
//
//  Created by plt3ch on 5/19/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import "RentApartmentsController.h"
#import "RentApartmentCoreDataController.h"

#define CHARACTERS @"abcdefghijklmnopqrstuwxyz "
#define UPPERCASE_CHARACTERS @"ABCDEFGHIJKLMNOPQRSTUWXYZ"

@interface RentApartmentsController ()

@property (nonatomic, strong) RentApartmentCoreDataController* coreDataController;

@end

@implementation RentApartmentsController

static NSString* apartmentsImages[] = {@"apartment.jpeg", @"apartment2.jpg", @"apartment3.jpg", @"apartment4.jpg"};

static RentApartmentsController* rentApartmentController;

+(id)sharedInstance{
    @synchronized(self){
        if (!rentApartmentController) {
            rentApartmentController = [[RentApartmentsController alloc] init];
        }
    }
    
    return rentApartmentController;
}

-(instancetype)init{
    if(rentApartmentController){
        [NSException raise:NSInternalInconsistencyException
                    format:@"[%@ %@] cannot be called; use +[%@ %@] instead",
         NSStringFromClass([self class]),
         NSStringFromSelector(_cmd),
         NSStringFromClass([self class]),
         NSStringFromSelector(@selector(sharedInstance))];
    }
    else{
        self = [super init];
        if(self){
            rentApartmentController = self;
            _coreDataController = [[RentApartmentCoreDataController alloc] init];
            _searchCriteria = [NSMutableDictionary dictionary];
            
            [self generateCities];
            [self generateApartmentTypes];
            [self generateQuarters];
            [self generateRandomApartments:60];
        }
    }
    
    return rentApartmentController;
}

-(NSFetchedResultsController *)fetchedResultsController{
    return [self.coreDataController fetchedResultsController];
}

- (NSFetchedResultsController *)fetchedCommentsResultsControllerForChosenApartment{
    return [self.coreDataController fetchedCommentsResultsControllerForApartment:self.chosenApartment];
}

-(void)loginUser:(User*)user{
    self.loggedUser = user;
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(performTimerOperationOnMainThread) userInfo:nil repeats:YES];
}

-(void)performTimerOperationOnMainThread{
    [self performSelectorOnMainThread:@selector(performOnTimerTick) withObject:nil waitUntilDone:YES];
}

-(void)performOnTimerTick{
    NSArray* quarters = [self.coreDataController quarters];
    NSArray* apartmentTypes = [self.coreDataController apartmentTypes];
    NSArray* apartments = [self.coreDataController apartments];
    NSInteger apartmentsCount = [apartments count];
    
    //Deleting apartment
    NSUInteger indexOfItemToDelete = (NSUInteger)arc4random_uniform((u_int32_t)apartmentsCount);
    Apartment* apartmentToDelete = [apartments objectAtIndex:indexOfItemToDelete];
    [self.coreDataController deleteApartment:apartmentToDelete];
    
    //Updating entry(entry should be deleted and recreated with the updated value for some reason otherwise at some point after few shuffles exception occurs!)
    NSUInteger indexOfItemToUpdate = (NSUInteger)arc4random_uniform((u_int32_t)(apartmentsCount-1));
    Apartment* apartmentToUpdate = [apartments objectAtIndex:indexOfItemToUpdate];
    [self.coreDataController deleteApartment:apartmentToDelete];
    Apartment* recreatedApartament = [NSEntityDescription insertNewObjectForEntityForName:@"Apartment" inManagedObjectContext:self.coreDataController.managedObjectContext];
    recreatedApartament.price = @((NSUInteger)arc4random_uniform((u_int32_t)100) * 10);
    recreatedApartament.quarter = apartmentToUpdate.quarter;
    recreatedApartament.apartamentType = apartmentToUpdate.apartamentType;
    recreatedApartament.imagePath = apartmentToUpdate.imagePath;
    recreatedApartament.publisher = apartmentToUpdate.publisher;
    [self.coreDataController saveContext];
    
    //Adding new apartment
    NSUInteger randomNumForQuarters = (NSUInteger)arc4random_uniform((u_int32_t)[quarters count]);
    NSUInteger randomNumForTypes = (NSUInteger)arc4random_uniform((u_int32_t)[apartmentTypes count]);
    NSUInteger randomNumForImageUrl = (NSUInteger)arc4random_uniform(4);
    NSInteger price = (NSUInteger)arc4random_uniform((u_int32_t)100) * 10;
    Quarter* quarter = [quarters objectAtIndex:randomNumForQuarters];
    ApartamentType* type = [apartmentTypes objectAtIndex:randomNumForTypes];
    [self.coreDataController addApartmentWithType:type AndQuarter:quarter AndPrice:@(price) AndImageUrl:apartmentsImages[randomNumForImageUrl] ByPublisher:nil withInfo:nil];
    
    
    NSLog(@"performOnTimer");
}

-(void)generateCities{
    [self.coreDataController addCityWithUniqueName:@"Sofia"];
    [self.coreDataController addCityWithUniqueName:@"Plovdiv"];
    [self.coreDataController addCityWithUniqueName:@"Varna"];
    [self.coreDataController addCityWithUniqueName:@"Burgas"];
    [self.coreDataController addCityWithUniqueName:@"Pleven"];
    [self.coreDataController addCityWithUniqueName:@"Ruse"];
    [self.coreDataController addCityWithUniqueName:@"New York"];
    [self.coreDataController addCityWithUniqueName:@"London"];
}

-(void)generateApartmentTypes{
    [self.coreDataController addApartmentType:@"Single"];
    [self.coreDataController addApartmentType:@"2Rooms"];
    [self.coreDataController addApartmentType:@"3Rooms"];
    [self.coreDataController addApartmentType:@"4Rooms"];
}

-(void)generateQuarters{
    NSArray* cities = [self.coreDataController cities];
    NSUInteger citiesCount = [cities count];
    for (int i = 0; i < citiesCount; i++) {
        for (int j = 0; j < 8; j++) {
            NSString* quarterName = [NSString stringWithFormat:@"Quarter %d", j];
            City* city = [cities objectAtIndex:i];
            [self.coreDataController addQuarterWithUniqueName:quarterName AndCity:city];
        }
    }
}

-(void)generateRandomApartments:(NSInteger)limit{
    NSArray* apartments = [self.coreDataController apartments];
    NSArray* quarters = [self.coreDataController quarters];
    NSArray* apartmentTypes = [self.coreDataController apartmentTypes];
    NSInteger countTillLimit = limit - [apartments count];
    for (int i = 0; i < countTillLimit; i++) {
        NSUInteger randomNumForQuarters = (NSUInteger)arc4random_uniform((u_int32_t)[quarters count]);
        NSUInteger randomNumForTypes = (NSUInteger)arc4random_uniform((u_int32_t)[apartmentTypes count]);
        NSInteger price = (NSUInteger)arc4random_uniform((u_int32_t)100) * 10;
         NSUInteger randomNumForImageUrl = (NSUInteger)arc4random_uniform(4);
        
        Quarter* quarter = [quarters objectAtIndex:randomNumForQuarters];
        ApartamentType* type = [apartmentTypes objectAtIndex:randomNumForTypes];
        [self.coreDataController addApartmentWithType:type AndQuarter:quarter AndPrice:@(price) AndImageUrl:apartmentsImages[randomNumForImageUrl] ByPublisher:nil withInfo:nil];
    }
}

-(NSArray *)apartmentTypes{
    return [self.coreDataController apartmentTypes];
}

-(bool)isUsernameUnique:(NSString*)username{
    NSArray* users = [self.coreDataController usersWithUsername:username];
    if([users count] > 0){
        return false;
    }
    
    return true;
}

-(User*)findUserWithUsername:(NSString*)username AndPassword:(NSString*)password{
    NSArray* users = [self.coreDataController usersWithUsername:username andPassword:password];
    if([users count] != 1){
        return nil;
    }
    
    return [users objectAtIndex:0];
}

-(User*)addUser:(UserModel*)user{
    return [self.coreDataController addUser:user];
}

-(NSArray*)apartmentTypesWithType:(NSString*)type{
    return [self.coreDataController apartmentTypesWithType:type];
}

-(void)addCityWithUniqueName:(NSString*)name{
    [self.coreDataController addCityWithUniqueName:name];
}
-(NSArray*)citiesWithName:(NSString*)name{
    return [self.coreDataController citiesWithName:name];
}

-(void)addQuarterWithUniqueName:(NSString*)name AndCity:(City*)city{
    [self.coreDataController addQuarterWithUniqueName:name AndCity:city];
}
-(NSArray*)quartersWithName:(NSString*)name inCity:(City*)city{
    return [self.coreDataController quartersWithName:name inCity:city];
}

-(void)addApartmentWithType:(ApartamentType*)type
                 AndQuarter:(Quarter*)quarter
                   AndPrice:(NSNumber*)price
                AndImageUrl:(NSString*)imageUrl
                ByPublisher:(User*)user
                   withInfo:(NSString*)info{
    [self.coreDataController addApartmentWithType:type AndQuarter:quarter AndPrice:price AndImageUrl:imageUrl ByPublisher:user withInfo:info];
}

-(Comment*)newComment{
    return [self.coreDataController newComment];
}


-(void)saveContext{
    [self.coreDataController saveContext];
}

-(NSString*) generateRandomStringWithLength:(NSUInteger)length{
    NSMutableString* result = [NSMutableString string];
    NSUInteger randonIndex = (NSUInteger)arc4random_uniform((u_int32_t)[UPPERCASE_CHARACTERS length]);
    [result appendFormat:@"%c",[UPPERCASE_CHARACTERS characterAtIndex:randonIndex]];
    for (int i = 0; i < length; i++) {
        randonIndex = (NSUInteger)arc4random_uniform((u_int32_t)[CHARACTERS length]);
        [result appendFormat:@"%c",[CHARACTERS characterAtIndex:randonIndex]];
    }
    
    return result;
}

@end
