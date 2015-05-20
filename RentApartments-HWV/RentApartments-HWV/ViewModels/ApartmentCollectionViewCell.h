//
//  ApartmentCollectionViewCell.h
//  RentApartments-HWV
//
//  Created by plt3ch on 5/19/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Apartment+Image.h"
#import "ApartamentType.h"
#import "City.h"
#import "Quarter.h"

@interface ApartmentCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) Apartment* apartment;

@end
