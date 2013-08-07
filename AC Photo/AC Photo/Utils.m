//
//  Utils.m
//  AC Photo
//
//  Created by noname on 8/6/13.
//  Copyright (c) 2013 test. All rights reserved.
//

#include "Utils.h"

@implementation Utils

// This method simply creates a download
// title - Bold title
// message - message on the message box
- (void)createDialog:(NSString *)title dialogMessage:(NSString*)message
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

// Creates image from a color
- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end