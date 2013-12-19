//
//  Utils.h
//  AC Photo
//
//  Created by noname on 8/6/13.
//  Copyright (c) 2013 test. All rights reserved.


#import <UIKit/UIKit.h>

@class Utils;

@interface Utils : NSObject

// Creates image from a color
- (UIImage *)imageWithColor:(UIColor *)color;

//Check system version
- (BOOL)sysVersionEqualTo:(NSString *)version;
- (BOOL)sysVersionGreaterThan:(NSString *)version;
- (BOOL)sysVersionGreaterThanOrEqualTo:(NSString *)version;
- (BOOL)sysVersionLessThan:(NSString *)version;
- (BOOL)sysVersionLessThanOrEqualTo:(NSString *)version;

//gets the navbar height depending on version
- (int)getNavBarHeight:(int)navBar withStatusbar:(int)statBar;

//Animations for the internet warning views
- (BOOL) animationSlideIn:(UIView *)internetWarning shouldUseiOS7Offset:(BOOL)is7 navBarHeight:(int)navHeight;
- (BOOL) animationSlideOut:(UIView *)internetWarning;
@end