//
//  FlickrEntry.h
//  Flickr-HWVI
//
//  Created by plt3ch on 6/1/15.
//  Copyright (c) 2015 plt3ch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FlickrEntry : NSManagedObject

@property (nonatomic, retain) NSString * flickrEntryId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * publishedDate;
@property (nonatomic, retain) NSString * authorName;
@property (nonatomic, retain) NSString * flickrImageLink;
@property (nonatomic, retain) NSString * flickrAlternativeLink;
@property (nonatomic, retain) NSData * flickrImageData;

@end
