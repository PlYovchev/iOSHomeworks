//
//  Event.m
//  Events_HWIV
//
//  Created by plt3ch on 4/27/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import "Event.h"

@implementation Event

-(instancetype)initEventWithTitle:(NSString *)title andOwnerName:(NSString *)owner andImage:(UIImage *)image andTargetedDate:(NSDate *)date andDescription:(NSString *)description{
    self = [super init];
    if(self){
        _title = title;
        _ownerName = owner;
        _image = image;
        _date = date;
        _eventDescription = description;
    }
    
    return self;
}

@end
