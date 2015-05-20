//
//  Apartment.h
//  RentApartments-HWV
//
//  Created by plt3ch on 5/19/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ApartamentType, Quarter, User;

@interface Apartment : NSManagedObject

@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) ApartamentType *apartamentType;
@property (nonatomic, retain) Quarter *quarter;
@property (nonatomic, retain) User *publisher;

@end
