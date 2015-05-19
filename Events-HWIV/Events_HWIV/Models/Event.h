//
//  Event.h
//  Events_HWIV
//
//  Created by plt3ch on 4/27/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Event : NSObject

@property (nonatomic) NSString* title;
@property (nonatomic) NSString* ownerName;
@property (nonatomic) UIImage* image;
@property (nonatomic) NSDate* date;
@property (nonatomic) NSString* eventDescription;

-(instancetype)initEventWithTitle:(NSString*)title
                     andOwnerName:(NSString*)owner
                         andImage:(UIImage*)image
                  andTargetedDate:(NSDate*)date
                   andDescription:(NSString*) description;

-(instancetype)initEventWithTitle:(NSString *)title
                     andOwnerName:(NSString *)owner
                  andTargetedDate:(NSDate *)date
                   andDescription:(NSString *)description;
@end
