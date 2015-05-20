//
//  RegisterViewController.m
//  RentApartments-HWV
//
//  Created by plt3ch on 5/19/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import "RegisterViewController.h"
#import "NSString+Validation.h"
#import "RentApartmentsController.h"
#import "UserModel.h"

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)signInButtonTapped:(id)sender {
    if(![self validateFields]){
        [self generateSimpleAlertControllerWithTitle:@"Incorrect fields!" andMessage:@"Some of the obligatory fields has incorrect or missing data!"];
        return;
    }
    
    RentApartmentsController *controller = [RentApartmentsController sharedInstance];
    
    NSString* username = self.usernameTextField.text;
    if([controller isUsernameUnique:username]){
        UserModel* user = [[UserModel alloc] init];
        user.username = username;
        user.password = self.passwordTextField.text;
        user.firstname = self.firstnameTextField.text;
        user.lastname = self.lastnameTextField.text;
        user.address = self.addressTextField.text;
        user.age = @([self.ageTextField.text integerValue]);
        
        User* userEntry = [controller addUser:user];
        
        [controller loginUser:userEntry];
        [self navigateToMainNavigationController];
    }
    else{
        [self generateSimpleAlertControllerWithTitle:@"Error!" andMessage:@"The chosen username already exists!"];
    }
}

-(void)navigateToMainNavigationController{
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* mainNavigationViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"rentControllerMainNav"];
    [self presentViewController:mainNavigationViewController animated:YES completion:nil];
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

-(bool)validateFields{
    if([self.usernameTextField.text isEmpty]){
        return false;
    }
    
    if([self.passwordTextField.text isEmpty]){
        return false;
    }
    
    return true;
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
