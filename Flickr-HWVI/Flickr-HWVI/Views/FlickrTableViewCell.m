//
//  FlickrTableViewCell.m
//  Flickr-HWVI
//
//  Created by plt3ch on 6/1/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import "FlickrTableViewCell.h"

@interface FlickrTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *flickrImageView;

@end

@implementation FlickrTableViewCell

-(void)setFlickrEntry:(FlickrEntry *)flickrEntry{
    _flickrEntry = flickrEntry;
    
    self.titleLabel.text = flickrEntry.title;
    self.authorNameLabel.text = [NSString stringWithFormat:@"by %@", flickrEntry.authorName];
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy/MM/dd-HH:mm:ss"];
    NSString* publishedDate = [df stringFromDate:flickrEntry.publishedDate];
    self.dateLabel.text = [NSString stringWithFormat:@"at %@", publishedDate];
    
    if(flickrEntry != nil && flickrEntry.flickrImageData != nil){
        self.flickrImageView.image = [UIImage imageWithData:flickrEntry.flickrImageData];
    }
    else if(flickrEntry != nil){
        [_flickrEntry downloadFlickrImageWithCompletionBlock:^{
            self.flickrImageView.image = [UIImage imageWithData:_flickrEntry.flickrImageData];
        }];
    }
}

-(void)prepareForReuse{
    self.flickrEntry = nil;
    self.flickrImageView.image = nil;
}

@end
