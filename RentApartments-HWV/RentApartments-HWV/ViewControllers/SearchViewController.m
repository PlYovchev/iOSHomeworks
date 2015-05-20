//
//  SearchViewController.m
//  RentApartments-HWV
//
//  Created by plt3ch on 5/20/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import "SearchViewController.h"
#import "RentApartmentsController.h"
#import "ApartamentType.h"
#import "NSString+Validation.h"

@interface SearchViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *apartmentTypeField;
@property (weak, nonatomic) IBOutlet UITextField *priceFromField;
@property (weak, nonatomic) IBOutlet UITextField *priceToField;
@property (weak, nonatomic) IBOutlet UITextField *locationField;

@property (nonatomic) NSArray* apartmentTypes;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    RentApartmentsController* controller = [RentApartmentsController sharedInstance];
    self.apartmentTypes = [controller apartmentTypes];
    
    UIPickerView* pickerView = [[UIPickerView alloc] init];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    self.apartmentTypeField.inputView = pickerView;

    self.apartmentTypeField.text = [controller.searchCriteria objectForKey:@"type"];
    self.priceFromField.text = [controller.searchCriteria objectForKey:@"priceFrom"];
    self.priceToField.text = [controller.searchCriteria objectForKey:@"priceTo"];
    self.locationField.text = [controller.searchCriteria objectForKey:@"location"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)searchButtonTapped:(id)sender {
    
    NSMutableArray* predicates = [NSMutableArray array];
    RentApartmentsController* controller = [RentApartmentsController sharedInstance];
    
    NSString* apartmentTypeText = self.apartmentTypeField.text;
    if(![apartmentTypeText isEmpty]){
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"apartamentType.type == %@",apartmentTypeText];
        [predicates addObject:predicate];
        [controller.searchCriteria setObject:apartmentTypeText forKey:@"type"];
    }

    NSString* priceFrom = self.priceFromField.text;
    if(![priceFrom isEmpty]){
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"price > %@",priceFrom];
        [predicates addObject:predicate];
        [controller.searchCriteria setObject:priceFrom forKey:@"priceFrom"];
    }
    
    NSString* priceTo = self.priceToField.text;
    if(![priceTo isEmpty]){
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"price < %@",priceTo];
        [predicates addObject:predicate];
        [controller.searchCriteria setObject:priceTo forKey:@"priceTo"];
    }
    
    NSString* location = self.locationField.text;
    if(![location isEmpty]){
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"quarter.name CONTAINS[c] %@ OR quarter.city.name CONTAINS[c] %@",location, location];
        [predicates addObject:predicate];
        [controller.searchCriteria setObject:location forKey:@"location"];
    }
    
    NSPredicate* finalPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
    
    [NSFetchedResultsController deleteCacheWithName:nil];
    controller.fetchedResultsController.fetchRequest.predicate = finalPredicate;

    self.searchPredicatesApplied();
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

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
    self.apartmentTypeField.text = [apartmentType type];
    [self.apartmentTypeField resignFirstResponder];
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
