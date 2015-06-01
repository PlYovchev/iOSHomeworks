//
//  FlickrEntriesTableViewController.m
//  Flickr-HWVI
//
//  Created by plt3ch on 5/30/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import "FlickrEntriesTableViewController.h"
#import "FlickrController.h"
#import "FlickrTableViewCell.h"
#import "FlickrEntry+ImageDownloader.h"

#define DOWNLOAD_IMAGES_PER_BATCH_COUNT 5

@interface FlickrEntriesTableViewController () <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
//Collection to keep track of the flickr images that are being downloaded
@property (nonatomic) NSMutableSet* currentlyDownloading;

@end

@implementation FlickrEntriesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(getLatestFlickrEntriesFromService)
                  forControlEvents:UIControlEventValueChanged];
    
    FlickrController* flickrController = [FlickrController sharedInstance];
    self.fetchedResultsController = flickrController.fetchedResultsController;
    self.fetchedResultsController.delegate = self;
    
    [self getLatestFlickrEntriesFromService];
    
    [self performFetch];
}

-(void)viewDidAppear:(BOOL)animated{
    FlickrController* flickrController = [FlickrController sharedInstance];
    flickrController.chosenFlickrEntry = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

-(void)getLatestFlickrEntriesFromService{
    FlickrController* flickrController = [FlickrController sharedInstance];
    
    [flickrController downloadFlickrEntriesFromServiceWithCompletionHandler:^{
        [self.refreshControl endRefreshing];
    }];
}

-(void)performFetch{
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
}

-(void)lazyLoadImagesWithCount:(NSInteger)count fromIndexPath:(NSIndexPath*)indexPath{
    NSInteger innerCount = 0;
    id sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section];
    NSInteger lenght = [sectionInfo numberOfObjects];
    
    if(!self.currentlyDownloading){
        self.currentlyDownloading = [NSMutableSet set];
    }
    
    for (NSInteger i = indexPath.row; i < lenght; i++) {
        NSIndexPath* newIndexPath = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
        FlickrEntry* entry = [self.fetchedResultsController objectAtIndexPath:newIndexPath];
        
        //if the image data is null and the current entry hasnt been marked as being downloaded at the moment, initiate download for it
        if(!entry.flickrImageData && ![self.currentlyDownloading containsObject:entry.flickrEntryId]){
            [self.currentlyDownloading addObject:entry.flickrEntryId];
            [entry downloadFlickrImageWithCompletionBlock:^{
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:YES];
                [self.currentlyDownloading removeObject:entry.flickrEntryId];
            }];
        }
        
        innerCount++;
        
        if(innerCount == count){
            break;
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    id sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FlickrTableViewCell *flickrCell = [tableView dequeueReusableCellWithIdentifier:@"flickrCell" forIndexPath:indexPath];
    
    [self configureCell:flickrCell atIndexPath:indexPath];
    
    return flickrCell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    FlickrEntry* flickrEntry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if(indexPath.row % DOWNLOAD_IMAGES_PER_BATCH_COUNT == 0){
        [self lazyLoadImagesWithCount:DOWNLOAD_IMAGES_PER_BATCH_COUNT fromIndexPath:indexPath];
    }
    
    FlickrTableViewCell* flickrCell = (FlickrTableViewCell*)cell;
    flickrCell.flickrEntry = flickrEntry;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath
                                                                                                      *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
        break;
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    FlickrEntry* entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UIImage* image = [UIImage imageWithData:entry.flickrImageData];
    CGFloat imageCellWidth = tableView.frame.size.width - 20;
    CGFloat width = image.size.width;
    CGFloat ratio = width / imageCellWidth;
    CGFloat height = 0;
    if(ratio != 0){
        height = image.size.height / ratio;
    }

    return height + 110;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FlickrController* flickrController = [FlickrController sharedInstance];
    flickrController.chosenFlickrEntry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    UIViewController* viewContrller = [self.storyboard instantiateViewControllerWithIdentifier:@"flickrWebViewController"];
    [self.navigationController pushViewController:viewContrller animated:YES];
}

@end
