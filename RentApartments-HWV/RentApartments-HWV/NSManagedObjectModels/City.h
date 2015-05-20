//
//  City.h
//  RentApartments-HWV
//
//  Created by plt3ch on 5/19/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Quarter;

@interface City : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *quarters;
@end

@interface City (CoreDataGeneratedAccessors)

- (void)addQuartersObject:(Quarter *)value;
- (void)removeQuartersObject:(Quarter *)value;
- (void)addQuarters:(NSSet *)values;
- (void)removeQuarters:(NSSet *)values;

@end
