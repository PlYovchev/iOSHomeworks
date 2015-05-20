//
//  LoginViewController.m
//  RentApartments-HWV
//
//  Created by plt3ch on 5/19/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import "LoginViewController.h"
#import "NSString+Validation.h"
#import "RentApartmentsController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonTapped:(id)sender {
    if(![self validateFields]){
        [self generateSimpleAlertControllerWithTitle:@"Incorrect fields!" andMessage:@"Some of the obligatory fields has missing data!"];
        return;
    }
    
    NSString* username = self.usernameTextField.text;
    NSString* password = self.passwordTextField.text;
    
    RentApartmentsController* controller = [RentApartmentsController sharedInstance];
    User* user = [controller findUserWithUsername:username AndPassword:password];
    if(user){
        [controller loginUser:user];
        [self navigateToMainNavigationController];
    }
    else{
        [self generateSimpleAlertControllerWithTitle:@"Error" andMessage:@"Wrong username or password!"];
    }
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

-(void)navigateToMainNavigationController{
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* mainNavigationViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"rentControllerMainNav"];
    [self presentViewController:mainNavigationViewController animated:YES completion:nil];
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
