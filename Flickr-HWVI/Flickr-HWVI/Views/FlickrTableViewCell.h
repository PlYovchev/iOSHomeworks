//
//  FlickrTableViewCell.h
//  Flickr-HWVI
//
//  Created by plt3ch on 6/1/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrEntry+ImageDownloader.h"

@interface FlickrTableViewCell : UITableViewCell

@property (nonatomic) FlickrEntry* flickrEntry;

@end
