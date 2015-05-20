//
//  Quarter.h
//  RentApartments-HWV
//
//  Created by plt3ch on 5/19/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Apartment, City;

@interface Quarter : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) City *city;
@property (nonatomic, retain) NSSet *apartments;
@end

@interface Quarter (CoreDataGeneratedAccessors)

- (void)addApartmentsObject:(Apartment *)value;
- (void)removeApartmentsObject:(Apartment *)value;
- (void)addApartments:(NSSet *)values;
- (void)removeApartments:(NSSet *)values;

@end
