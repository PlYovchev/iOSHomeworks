//
//  EventViewCell.m
//  Events_HWIV
//
//  Created by plt3ch on 4/26/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import "EventViewCell.h"

@interface EventViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblOwner;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;

@end

@implementation EventViewCell

-(void)setEvent:(Event *)event{
    _event = event;
    
    [self updateEventCellViews];
}

-(void)updateEventCellViews{
    self.imageView.image = self.event.image;
    self.lblTitle.text = self.event.title;
    self.lblOwner.text = self.event.ownerName;
    
    NSCharacterSet* charactersSet = [NSCharacterSet characterSetWithCharactersInString:@".?!"];
    NSArray* descriptionSentences = [self.event.eventDescription componentsSeparatedByCharactersInSet:charactersSet];
    NSMutableString* description = [NSMutableString stringWithString:descriptionSentences[0]];
    [description appendString:@"!"];
    self.lblDescription.text = description;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm"];
    NSString* time = [df stringFromDate:self.event.date];
    self.lblTime.text = time;
}

@end
