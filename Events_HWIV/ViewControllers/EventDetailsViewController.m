//
//  EventDetailsViewController.m
//  Events_HWIV
//
//  Created by plt3ch on 4/28/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import "EventDetailsViewController.h"
#import "EventsController.h"

@interface EventDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblEventTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblEventOwner;
@property (weak, nonatomic) IBOutlet UILabel *lblEventDate;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewEvent;
@property (weak, nonatomic) IBOutlet UITextView *txtEventDescription;

@property (nonatomic) NSArray* varialbeContraints;

@end

@implementation EventDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setInitialContraints];
    
    EventsController* eventsController = [EventsController sharedEventController];
    Event* event = eventsController.chosenEvent;
    self.lblEventTitle.text = event.title;
    self.lblEventOwner.text = event.ownerName;
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"EEE dd MMM HH:mm"];
    self.lblEventDate.text = [df stringFromDate:event.date];
//    self.imageViewEvent.image = event.image;
    self.txtEventDescription.text = event.eventDescription;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    [self.view removeConstraints:self.varialbeContraints];
    
    NSDictionary* views = @{@"lblEventTitle": self.lblEventTitle,
                            @"lblEventOwner": self.lblEventOwner,
                            @"lblEventDate": self.lblEventDate,
                            @"imageViewEvent": self.imageViewEvent,
                            @"txtEventDescription": self.txtEventDescription};
    
    self.varialbeContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-UPPER_MARGIN-[lblEventTitle]-20-[lblEventDate]-(20)-[imageViewEvent(>=50)]-25-[txtEventDescription(>=50)]-(25)-|" options:0 metrics:@{@"UPPER_MARGIN":@(self.navigationController.navigationBar.frame.size.height+10)} views:views];
    [self.view addConstraints:self.varialbeContraints];
}

-(void)setInitialContraints{
    self.lblEventTitle.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblEventOwner.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblEventDate.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageViewEvent.translatesAutoresizingMaskIntoConstraints = NO;
    self.txtEventDescription.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary* views = @{@"lblEventTitle": self.lblEventTitle,
                            @"lblEventOwner": self.lblEventOwner,
                            @"lblEventDate": self.lblEventDate,
                            @"imageViewEvent": self.imageViewEvent,
                            @"txtEventDescription": self.txtEventDescription};
    
    NSArray* constraintsHorizontalUpperLabels = [NSLayoutConstraint constraintsWithVisualFormat:@"|-(>=5)-[lblEventTitle]-30-[lblEventOwner]-(>=5)-|" options:NSLayoutFormatAlignAllTop metrics:nil views:views];
    self.varialbeContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-UPPER_MARGIN-[lblEventTitle]-20-[lblEventDate]-(20)-[imageViewEvent(>=50)]-25-[txtEventDescription(>=50)]-(25)-|" options:0 metrics:@{@"UPPER_MARGIN":@(self.navigationController.navigationBar.frame.size.height + 30)} views:views];
    
    [self.view addConstraints:self.varialbeContraints];
    [self.view addConstraints:constraintsHorizontalUpperLabels];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblEventTitle attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:-15]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.lblEventDate attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.lblEventTitle attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imageViewEvent attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imageViewEvent attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:15]];
    
    //   [self.imageViewEvent addConstraint:[NSLayoutConstraint constraintWithItem:self.imageViewEvent attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]];
    
    [self.imageViewEvent addConstraint:[NSLayoutConstraint constraintWithItem:self.imageViewEvent attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:275]];
    
    [self.imageViewEvent addConstraint:[NSLayoutConstraint constraintWithItem:self.imageViewEvent attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.imageViewEvent attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    [self.imageViewEvent setContentHuggingPriority:250 forAxis:UILayoutConstraintAxisVertical];
    [self.imageViewEvent setContentHuggingPriority:250 forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.imageViewEvent setContentCompressionResistancePriority:250 forAxis:UILayoutConstraintAxisVertical];
    [self.imageViewEvent setContentCompressionResistancePriority:250 forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-20-[txtEventDescription]-20-|" options:0 metrics:nil views:views]];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
