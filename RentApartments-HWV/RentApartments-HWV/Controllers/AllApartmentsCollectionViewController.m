//
//  AllApartmentsCollectionViewController.m
//  RentApartments-HWV
//
//  Created by plt3ch on 5/19/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "AllApartmentsCollectionViewController.h"
#import "RentApartmentsController.h"
#import "ApartmentCollectionViewCell.h"
#import "SearchViewController.h"


@interface AllApartmentsCollectionViewController () <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation AllApartmentsCollectionViewController

static NSString * const reuseIdentifier = @"apartmentViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RentApartmentsController* controller = [RentApartmentsController sharedInstance];
    self.fetchedResultsController = controller.fetchedResultsController;
    self.fetchedResultsController.delegate = self;
    
    [self performFetch];
}

-(void)viewDidAppear:(BOOL)animated{
    RentApartmentsController* controller = [RentApartmentsController sharedInstance];
    controller.chosenApartment = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)performFetch{
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
}

- (IBAction)searchButtonTapped:(id)sender {
    SearchViewController* searchViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchViewControllerId"];
    searchViewController.searchPredicatesApplied = ^{
        [self performFetch];
        [self.collectionView reloadData];
    };
    
    UIPopoverController* popOverController = [[UIPopoverController alloc] initWithContentViewController:searchViewController];
    popOverController.popoverContentSize = CGSizeMake(300, 250);
    [popOverController presentPopoverFromBarButtonItem:sender
                              permittedArrowDirections:UIPopoverArrowDirectionUp
                                              animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    id sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ApartmentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Apartment* apartment = [self.fetchedResultsController objectAtIndexPath:indexPath];
    ApartmentCollectionViewCell* apartmentCell = (ApartmentCollectionViewCell*)cell;
    apartmentCell.apartment = apartment;
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath
                                                                                                      *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    UICollectionView *collectionView = self.collectionView;
    switch(type) {
        case NSFetchedResultsChangeInsert:
//            [collectionView reloadData];
            [collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]];
            break;
        case NSFetchedResultsChangeDelete:
//           [collectionView reloadData];
            [collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[collectionView cellForItemAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
//            [collectionView reloadData];
            [collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
            [collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]];
        break;
    }
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    Apartment* apartment = [self.fetchedResultsController objectAtIndexPath:indexPath];
    RentApartmentsController* controller = [RentApartmentsController sharedInstance];
    controller.chosenApartment = apartment;
}

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
