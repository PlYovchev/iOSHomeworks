//
//  EventsController.m
//  Events_HWIV
//
//  Created by plt3ch on 4/27/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import "EventsController.h"

typedef NSComparisonResult (^CompareEventsDates)(id firstEvent, id secondEvent);
static EventsController *eventController;

@interface EventsController ()

//Array to contain the keys of the 'events' dictionary but sorted in ascending order!
@property (nonatomic, strong) NSMutableArray* sortedDayKeys;

@end

@implementation EventsController{
    CompareEventsDates comparatorEventsDates;
}

+(id)sharedEventController{
    @synchronized(self){
        if (!eventController) {
            eventController = [[EventsController alloc] init];
        }
    }
    
    return eventController;
}

-(instancetype)init{
    if(eventController){
        NSException* exception = [NSException exceptionWithName:@"InstanceExists" reason:@"Get an instance of that class by 'sharedEventController'" userInfo:nil];
        @throw exception;
    }
    else{
        self = [super init];
        if(self){
            _events = [NSMutableDictionary dictionary];
            _sortedDayKeys = [NSMutableArray array];
            comparatorEventsDates = ^NSComparisonResult(id firstEvent, id secondEvent){
                NSDate* firstDate = ((Event*)firstEvent).date;
                NSDate* secondDate= ((Event*)secondEvent).date;
                return [firstDate compare:secondDate];
            };
        }
    }
    
    return self;
}


/*
 Adds new event in the 'events' dictionary. First it extracts the date up to day compoment from the new event. Then it is checked whether the date already exist in the dictionary - if not it is added in it as a key and in the sorted array 'sortedDayKeys' and the array is sorted again (this should be optimized). Then the event is added in the array for the corresponding key and that array is sorted too.
 */
-(void)addEvent:(Event*)event{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:event.date];
    NSDate* date = [calendar dateWithEra:1 year:components.year month:components.month day:components.day hour:0 minute:0 second:0 nanosecond:0];
    
    if(![self.events objectForKey:date]){
        [self.events setObject:[NSMutableArray array] forKey:date];
        [self.sortedDayKeys addObject:date];
        [self.sortedDayKeys sortUsingComparator:^(id firstDate, id secondDate){
            return [firstDate compare:secondDate];
        }];
    }
    
    NSMutableArray* eventsForCurrentDay = [self.events objectForKey:date];
    [eventsForCurrentDay addObject:event];
    [eventsForCurrentDay sortUsingComparator:comparatorEventsDates];
}

-(NSArray*)getSortedKeys{
    return [NSArray arrayWithArray:self.sortedDayKeys];
}

-(void)populateEvents{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* dc = [[NSDateComponents alloc] init];
    dc.month = 5;
    dc.year = 2015;
    dc.day = 14;
    dc.hour = 22;
    dc.minute = 0;
    dc.second = 0;
    NSDate* date = [[NSCalendar currentCalendar] dateFromComponents:dc];
    
    Event* eventOne = [[Event alloc] initEventWithTitle:@"Birthday" andOwnerName:@"Pesho" andImage:[UIImage imageNamed:@"event1.jpg"] andTargetedDate:date andDescription:@"Gosho's birthday. Get the present and go get drunk"];
    
    NSDate* dateTwo = [calendar dateWithEra:1 year:2015 month:5 day:14 hour:11 minute:30 second:0 nanosecond:0];
    Event* eventTwo = [[Event alloc] initEventWithTitle:@"Buy present" andOwnerName:@"Pesho" andImage:[UIImage imageNamed:@"event2.jpeg"] andTargetedDate:dateTwo andDescription:@"Go buy present for gosho's birthday. Get something!"];
    
    NSDate* dateThree = [calendar dateWithEra:1 year:2015 month:5 day:14 hour:21 minute:30 second:0 nanosecond:0];
    Event* eventThree = [[Event alloc] initEventWithTitle:@"Meeting before bd" andOwnerName:@"Pesho" andImage:[UIImage imageNamed:@"event3.jpeg"] andTargetedDate:dateThree andDescription:@"Meet the others and go together to gosho's bd. Bring alcohol!"];
    
    NSDate* dateFour = [calendar dateWithEra:1 year:2015 month:7 day:12 hour:20 minute:30 second:0 nanosecond:0];
    Event* eventFour = [[Event alloc] initEventWithTitle:@"Concert" andOwnerName:@"Kolio" andImage:[UIImage imageNamed:@"event4.jpeg"] andTargetedDate:dateFour andDescription:@"Deep trance electro concert!"];
    
    NSDate* dateFive = [calendar dateWithEra:1 year:2015 month:6 day:10 hour:10 minute:30 second:0 nanosecond:0];
    Event* eventFive = [[Event alloc] initEventWithTitle:@"Buy tickets" andOwnerName:@"Kolio" andImage:[UIImage imageNamed:@"event4.jpeg"] andTargetedDate:dateFive andDescription:@"Buy tickets for the crazy upcoming concert!"];
    
    NSDate* dateSix = [calendar dateWithEra:1 year:2015 month:7 day:12 hour:19 minute:30 second:0 nanosecond:0];
    Event* eventSix = [[Event alloc] initEventWithTitle:@"Meeting before concert" andOwnerName:@"Kolio" andImage:[UIImage imageNamed:@"event5.jpg"] andTargetedDate:dateSix andDescription:@"Meet the other junkies before th concert! Bring ... stuff!"];
    
    NSDate* dateSeven = [calendar dateWithEra:1 year:2015 month:7 day:12 hour:18 minute:30 second:0 nanosecond:0];
    Event* eventSeven = [[Event alloc] initEventWithTitle:@"Prepare for the concert" andOwnerName:@"Kolio" andImage:[UIImage imageNamed:@"event1.jpg"] andTargetedDate:dateSeven andDescription:@"Start preparing for the concert so u dont be late."];
    
    NSDate* dateEight = [calendar dateWithEra:1 year:2015 month:7 day:12 hour:11 minute:30 second:0 nanosecond:0];
    Event* eventEight = [[Event alloc] initEventWithTitle:@"Wake up" andOwnerName:@"Kolio" andImage:[UIImage imageNamed:@"event3.jpeg"] andTargetedDate:dateEight andDescription:@"Just wake up. Concert today!"];
    
    [self addEvent:eventOne];
    [self addEvent:eventTwo];
    [self addEvent:eventThree];
    [self addEvent:eventFour];
    [self addEvent:eventFive];
    [self addEvent:eventSix];
    [self addEvent:eventSeven];
    [self addEvent:eventEight];
}

@end
