//
//  ApartmentCollectionViewCell.m
//  RentApartments-HWV
//
//  Created by plt3ch on 5/19/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import "ApartmentCollectionViewCell.h"

@interface ApartmentCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *apartmentTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *apartmentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *apartmentAddressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *apartmentImageView;

@end

@implementation ApartmentCollectionViewCell

-(void)setApartment:(Apartment *)apartment{
    _apartment = apartment;
    self.apartmentTypeLabel.text = apartment.apartamentType.type;
    self.apartmentPriceLabel.text = [NSString stringWithFormat:@"%ld$",(long)[apartment.price integerValue]];
    self.apartmentAddressLabel.text = [NSString stringWithFormat:@"%@ - %@", apartment.quarter.city.name, apartment.quarter.name];
    //self.apartmentImageView.image = apartment.apartmentImage;
}

@end
