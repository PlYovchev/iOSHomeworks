//
//  AllEventsViewController.m
//  Events_HWIV
//
//  Created by plt3ch on 4/26/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import "AllEventsViewController.h"
#import "EventViewCell.h"
#import "EventHeaderReusableView.h"
#import "EventsController.h"

@interface AllEventsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *allEventsCollectionView;

@end

@implementation AllEventsViewController

static NSString * const reuseCellIdentifier = @"EventCellIndentifier";
static NSString * const reuseHeaderIdentifier = @"EventHeaderView";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.allEventsCollectionView.delegate = self;
    self.allEventsCollectionView.dataSource = self;
 //   self.allEventsCollectionView.collectionViewLayout = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    EventsController* evensController = [EventsController sharedEventController];
    
    return [[evensController getSortedKeys] count];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    EventsController* evensController = [EventsController sharedEventController];
    NSArray* sortedKeys = [evensController getSortedKeys];
    NSMutableArray* eventsForCurrentSection = [evensController.events objectForKey:[sortedKeys objectAtIndex:section]];
    
    return [eventsForCurrentSection count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EventViewCell *eventCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseCellIdentifier forIndexPath:indexPath];
    
    EventsController* evensController = [EventsController sharedEventController];
    NSArray* sortedKeys = [evensController getSortedKeys];
    NSMutableArray* eventsForCurrentSection = [evensController.events objectForKey:[sortedKeys objectAtIndex:indexPath.section]];
    
    Event* event = [eventsForCurrentSection objectAtIndex:indexPath.row];
    eventCell.event = event;
    
    return eventCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(collectionView.frame) * 0.47f, 175);
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 10, 0, 5);
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    EventHeaderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                         UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeaderIdentifier forIndexPath:indexPath];
    
    EventsController* evensController = [EventsController sharedEventController];
    NSArray* sortedKeys = [evensController getSortedKeys];
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"EEE dd MMM"];
    headerView.lblDate.text = [df stringFromDate:[sortedKeys objectAtIndex:indexPath.section]];
    return headerView;
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
