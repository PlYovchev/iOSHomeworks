//
//  FlickrController.m
//  Flickr-HWVI
//
//  Created by plt3ch on 5/29/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import "FlickrController.h"
#import "FlickrCoreDataController.h"
#import "FlickrWebConnectionController.h"

@interface FlickrController ()

@property (nonatomic, strong) FlickrCoreDataController* coreDataController;
@property (nonatomic, strong) FlickrWebConnectionController* webController;

@end

@implementation FlickrController

static FlickrController* flickrController;

+(id)sharedInstance{
    @synchronized(self){
        if (!flickrController) {
            flickrController = [[FlickrController alloc] init];
        }
    }
    
    return flickrController;
}

-(instancetype)init{
    if(flickrController){
        [NSException raise:NSInternalInconsistencyException
                    format:@"[%@ %@] cannot be called; use +[%@ %@] instead",
         NSStringFromClass([self class]),
         NSStringFromSelector(_cmd),
         NSStringFromClass([self class]),
         NSStringFromSelector(@selector(sharedInstance))];
    }
    else{
        self = [super init];
        if(self){
            flickrController = self;
            _coreDataController = [[FlickrCoreDataController alloc] init];
            _webController = [[FlickrWebConnectionController alloc] init];
        }
    }
    
    return flickrController;
}

-(NSFetchedResultsController *)fetchedResultsController{
    return self.coreDataController.fetchedResultsController;
}

-(void)downloadFlickrEntriesFromServiceWithCompletionHandler:(void (^)(void)) completion{
    [self.webController downloadFlickrItemsFromServiceWithCompletionHandler:^(NSArray *array) {
        [self.coreDataController addFlickrEntriesFromArray:array];

        dispatch_async(dispatch_get_main_queue(), ^{
            completion();
        });
    }];
}

-(void)saveContext{
    [self.coreDataController saveContext];
}

@end
