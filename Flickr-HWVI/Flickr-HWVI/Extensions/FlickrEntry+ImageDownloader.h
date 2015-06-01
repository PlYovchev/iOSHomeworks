//
//  FlickrEntry+ImageDownloader.h
//  Flickr-HWVI
//
//  Created by plt3ch on 6/1/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import "FlickrEntry.h"

@interface FlickrEntry (ImageDownloader)

-(void)downloadFlickrImageWithCompletionBlock:(void (^)(void))completion;

@end
