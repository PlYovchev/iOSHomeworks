//
//  AddApartmentViewController.m
//  RentApartments-HWV
//
//  Created by plt3ch on 5/20/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import "AddApartmentViewController.h"
#import "RentApartmentsController.h"
#import "ApartamentType.h"
#import "NSString+Validation.h"

@interface AddApartmentViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *addApartmentImageButton;
@property (weak, nonatomic) IBOutlet UITextField *apartmentTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *quarterTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (nonatomic) NSArray* apartmentTypes;

@end

@implementation AddApartmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    RentApartmentsController* controller = [RentApartmentsController sharedInstance];
    self.apartmentTypes = [controller apartmentTypes];
    
    UIPickerView* pickerView = [[UIPickerView alloc] init];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    self.apartmentTypeTextField.inputView = pickerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doneButtonTapped:(id)sender {
    if(![self validateFields]){
        [self generateSimpleAlertControllerWithTitle:@"Incorrect fields!" andMessage:@"Some of the obligatory fields has missing data!"];
        return;
    }
    
    NSString* apartmentType = self.apartmentTypeTextField.text;
    NSString* city = self.cityTextField.text;
    NSString* quarter = self.quarterTextField.text;
    NSNumber* price = @([self.priceTextField.text integerValue]);
    NSString* info = self.descriptionTextView.text;
    
    RentApartmentsController* controller = [RentApartmentsController sharedInstance];
    
    [controller addCityWithUniqueName:city];
    City* cityEntry = [[controller citiesWithName:city] objectAtIndex:0];
    [controller addQuarterWithUniqueName:quarter AndCity:cityEntry];
    Quarter* quarterEntry = [[controller quartersWithName:quarter inCity:cityEntry] objectAtIndex:0];
    
    ApartamentType* typeEntry = [[controller apartmentTypesWithType:apartmentType] objectAtIndex:0];
    User* userEntry = [controller loggedUser];
    
    [controller addApartmentWithType:typeEntry AndQuarter:quarterEntry AndPrice:price AndImageUrl:nil ByPublisher:userEntry withInfo:info];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)generateSimpleAlertControllerWithTitle:(NSString*)title andMessage:(NSString*)message{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleCancel
                                   handler:nil];
    
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)selectApartmentImage:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

-(bool)validateFields{
    if([self.apartmentTypeTextField.text isEmpty]){
        return false;
    }
    
    if([self.cityTextField.text isEmpty]){
        return false;
    }
    
    if([self.quarterTextField.text isEmpty]){
        return false;
    }
    
    if([self.priceTextField.text isEmpty]){
        return false;
    }
    
    return true;
}

#pragma mark - Picker view datasource + delegete
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.apartmentTypes.count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return  1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    ApartamentType* apartmentType = [self.apartmentTypes objectAtIndex:row];
    return [apartmentType type];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    ApartamentType* apartmentType = [self.apartmentTypes objectAtIndex:row];
    self.apartmentTypeTextField.text = [apartmentType type];
    [self.apartmentTypeTextField resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Text field deleges
- (IBAction)textFieldEditDidBegin:(id)sender {
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if([textField isEqual:self.priceTextField]){
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        for (int i = 0; i < [string length]; i++) {
            unichar c = [string characterAtIndex:i];
            if (![myCharSet characterIsMember:c]) {
                return NO;
            }
        }
    }
    
    return YES;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [self.addApartmentImageButton setBackgroundImage:chosenImage forState:UIControlStateNormal];
    [self.addApartmentImageButton setTitle:@"" forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
