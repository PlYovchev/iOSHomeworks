//
//  ApartmentDetailsViewController.m
//  RentApartments-HWV
//
//  Created by plt3ch on 5/20/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import "ApartmentDetailsViewController.h"
#import "RentApartmentsController.h"
#import "Apartment.h"
#import "Quarter.h"
#import "City.h"

@interface ApartmentDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *apartmentTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *quarterLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;

@end

@implementation ApartmentDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    RentApartmentsController* controller = [RentApartmentsController sharedInstance];
    Apartment* apartment = controller.chosenApartment;
    
    self.apartmentTypeLabel.text = apartment.apartamentType.type;
    self.cityLabel.text = apartment.quarter.city.name;
    self.quarterLabel.text = apartment.quarter.name;
    self.priceLabel.text = [apartment.price stringValue];
    self.infoTextView.text = apartment.apartmentInfo;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)commentsButtonTapped:(id)sender {
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
