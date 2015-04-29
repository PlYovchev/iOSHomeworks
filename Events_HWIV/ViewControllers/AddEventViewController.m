//
//  AddEventViewController.m
//  Events_HWIV
//
//  Created by plt3ch on 4/29/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import "AddEventViewController.h"
#import "EventsController.h"

#define DATE_FORMAT @"EEE dd MMM HH:mm"

@interface AddEventViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageViewEvent;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtOwner;
@property (weak, nonatomic) IBOutlet UITextField *txtDate;
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnDone;

@property (strong, nonatomic) UIDatePicker *datePicker;

@end

@implementation AddEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageViewEvent.image = [UIImage imageNamed:@"eventPlaceholder.jpeg"];
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:120];
    self.datePicker.backgroundColor = [UIColor cyanColor];
    self.txtDate.inputView = self.datePicker;
    self.btnDone.enabled = NO;
    self.btnDone.title = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnDoneClick:(id)sender {
    self.btnDone.enabled = NO;
    self.btnDone.title = @"";
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:DATE_FORMAT];
    self.txtDate.text = [df stringFromDate:self.datePicker.date];
    [self.txtDate resignFirstResponder];
}

/*
 When 'btnAdd' is clicked first it is checked for empty fields and none of the required are empty the event is added and the viewcontroller is dismissed!
 */
- (IBAction)btnAddClick:(id)sender {
    if(![self checkFieldForValidData]){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Missing data!" message:@"Please fill up all fields!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else{
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        [df setDateFormat:DATE_FORMAT];
        NSDate* date = [df dateFromString:self.txtDate.text];
        Event* event = [[Event alloc] initEventWithTitle:self.txtTitle.text andOwnerName:self.txtOwner.text andTargetedDate:date andDescription:self.txtDescription.text];
        EventsController* eventController = [EventsController sharedEventController];
        [eventController addEvent:event];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(bool)checkFieldForValidData{
    bool allIsValid = YES;
    if([self.txtTitle.text length] == 0){
        allIsValid = NO;
    }
    
    if([self.txtOwner.text length] == 0){
        allIsValid = NO;
    }
    
    if([self.txtDate.text length] == 0){
        allIsValid = NO;
    }
    
    return allIsValid;
}

#pragma mark - TextField delegate
- (IBAction)txtDateEditingBegin:(id)sender {
    self.txtDate.text = @"";
    self.btnDone.title = @"Done";
    self.btnDone.enabled = YES;
}

- (IBAction)txtDateEditingEnd:(id)sender {
    self.btnDone.enabled = NO;
    self.btnDone.title = @"";
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:DATE_FORMAT];
    self.txtDate.text = [df stringFromDate:self.datePicker.date];
    [self.txtDate resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return NO;
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
