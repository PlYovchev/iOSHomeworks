//
//  FlickrEntry+ImageDownloader.m
//  Flickr-HWVI
//
//  Created by plt3ch on 6/1/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import "FlickrEntry+ImageDownloader.h"

@implementation FlickrEntry (ImageDownloader)

//Initiate download for the imageData for the current entry's image.The 'flickrImageData' property is marked as transient
//so it doesnt get stored in the database.
-(void)downloadFlickrImageWithCompletionBlock:(void (^)(void))completion{
    NSURL* imageURL = [NSURL URLWithString:self.flickrImageLink];
    dispatch_queue_t downloadQueue = dispatch_queue_create("imagedownloader", NULL);
    
    dispatch_async(downloadQueue, ^{
        NSData* imageData = [NSData dataWithContentsOfURL:imageURL];
        self.flickrImageData = [imageData copy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(completion){
                completion();
            }
        });
    });
}

@end
