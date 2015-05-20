//
//  CommentsViewController.m
//  RentApartments-HWV
//
//  Created by plt3ch on 5/20/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import "CommentsViewController.h"
#import <CoreData/CoreData.h>
#import "RentApartmentsController.h"
#import "Comment.h"
#import "CommentTableViewCell.h"

@interface CommentsViewController () <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

@property (strong, nonatomic) NSFetchedResultsController *fetchedCommentsResultsController;
@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.commentsTableView.delegate = self;
    self.commentsTableView.dataSource = self;
    
    RentApartmentsController* controller = [RentApartmentsController sharedInstance];
    self.fetchedCommentsResultsController = controller.fetchedCommentsResultsControllerForChosenApartment;
    self.fetchedCommentsResultsController.delegate = self;
    
    NSError *error;
    if (![[self fetchedCommentsResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addCommentButtonTapped:(id)sender {
    RentApartmentsController* controller = [RentApartmentsController sharedInstance];
    Comment* comment = [controller newComment];
    comment.commentText = self.commentTextView.text;
    comment.user = controller.loggedUser;
    comment.publishDate = [NSDate date];
    comment.apartment = controller.chosenApartment;
    
    [controller saveContext];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id sectionInfo = [[self.fetchedCommentsResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Comment* comment = [self.fetchedCommentsResultsController objectAtIndexPath:indexPath];
    CommentTableViewCell* commentCell = (CommentTableViewCell*)cell;
    commentCell.comment = comment;
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath
                                                                                                      *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.commentsTableView;
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
        break; }
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
