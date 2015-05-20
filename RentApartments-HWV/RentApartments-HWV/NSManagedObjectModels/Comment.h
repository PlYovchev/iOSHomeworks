//
//  Comment.h
//  RentApartments-HWV
//
//  Created by plt3ch on 5/20/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Apartment, User;

@interface Comment : NSManagedObject

@property (nonatomic, retain) NSString * commentText;
@property (nonatomic, retain) NSDate * publishDate;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) Apartment *apartment;

@end
