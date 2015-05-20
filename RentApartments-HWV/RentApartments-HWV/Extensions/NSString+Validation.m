//
//  NSString+Validation.m
//  AlbumOrganiser
//
//  Created by Lyubomir Vezev on 4/28/15.
//  Copyright (c) 2015 MentorMate. All rights reserved.
//

#import "NSString+Validation.h"

@implementation NSString (Validation)

- (BOOL)isEmpty {
    NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
    NSString *trimmedString = [self stringByTrimmingCharactersInSet:charSet];
    if ([trimmedString isEqualToString:@""]) {
        return YES;
    }
    return NO;
}
@end
