//
//  Apartment.h
//  RentApartments-HWV
//
//  Created by plt3ch on 5/20/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ApartamentType, NSManagedObject, Quarter, User;

@interface Apartment : NSManagedObject

@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * apartmentInfo;
@property (nonatomic, retain) ApartamentType *apartamentType;
@property (nonatomic, retain) User *publisher;
@property (nonatomic, retain) Quarter *quarter;
@property (nonatomic, retain) NSSet *comments;
@end

@interface Apartment (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(NSManagedObject *)value;
- (void)removeCommentsObject:(NSManagedObject *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

@end
