//
//  EventDetailsViewController.m
//  Events_HWIV
//
//  Created by plt3ch on 4/28/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import "EventDetailsViewController.h"

@interface EventDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblEventTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblEventOwner;
@property (weak, nonatomic) IBOutlet UILabel *lblEventDate;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewEvent;
@property (weak, nonatomic) IBOutlet UITextView *txtEventDescription;

@end

@implementation EventDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.lblEventTitle.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblEventOwner.translatesAutoresizingMaskIntoConstraints = NO;
    self.lblEventDate.translatesAutoresizingMaskIntoConstraints = NO;
//    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    
//    UILabel* lblShit = [[UILabel alloc] initWithFrame:CGRectMake(50, 150, 100, 70)];
//    lblShit.text = @"FUCKING SHIT";
//    lblShit.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.view addSubview:lblShit];
    NSDictionary* views = @{@"lblEventTitle": self.lblEventTitle};

//    NSArray* constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-[lblEventTitle]" options:0 metrics:nil views:views];
//    NSArray* constraintsV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[lblEventTitle]" options:0 metrics:nil views:views];
//    [self.view addConstraints:constraints];
//    [self.view addConstraints:constraintsV];

    
    NSLayoutConstraint* constr = [NSLayoutConstraint constraintWithItem:self.lblEventTitle
                                                              attribute:NSLayoutAttributeLeading
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.lblEventOwner
                                                              attribute:NSLayoutAttributeTrailing
                                                             multiplier:1.0
                                                               constant:10.0];
    
    [self.view addConstraint:constr];
    
    NSLayoutConstraint* constr2 = [NSLayoutConstraint constraintWithItem:self.lblEventDate
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:420];
    
    [self.view addConstraint:constr2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateViewConstraints{
    [super updateViewConstraints];




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
