//
//  NSString+Validation.h
//  AlbumOrganiser
//
//  Created by Lyubomir Vezev on 4/28/15.
//  Copyright (c) 2015 MentorMate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Validation)

@property (nonatomic, getter=isEmpty, readonly) BOOL empty;

@end
