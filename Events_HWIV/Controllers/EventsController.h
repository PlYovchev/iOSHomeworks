//
//  EventsController.h
//  Events_HWIV
//
//  Created by plt3ch on 4/27/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"

@interface EventsController : NSObject

@property (nonatomic, strong) NSMutableDictionary* events;

+(id)sharedEventController;

-(void)populateEvents;
-(NSArray*)getSortedKeys;

@end
