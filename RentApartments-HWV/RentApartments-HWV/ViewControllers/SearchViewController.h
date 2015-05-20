//
//  SearchViewController.h
//  RentApartments-HWV
//
//  Created by plt3ch on 5/20/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SearchPredicatesApplied)();

@interface SearchViewController : UIViewController

@property (copy) SearchPredicatesApplied searchPredicatesApplied;

@end
