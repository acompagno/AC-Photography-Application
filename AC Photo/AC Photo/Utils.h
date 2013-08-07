//
//  Utils.h
//  AC Photo
//
//  Created by noname on 8/6/13.
//  Copyright (c) 2013 test. All rights reserved.


#import <UIKit/UIKit.h>

@class Utils;

@interface Utils : NSObject

// http://stackoverflow.com/questions/683211/method-syntax-in-objective-c
// This is a message method in order to practice creating methods in iOS
- (void)createDialog:(NSString *)title dialogMessage:(NSString *)message;

// Creates image from a color
- (UIImage *)imageWithColor:(UIColor *)color;

@end