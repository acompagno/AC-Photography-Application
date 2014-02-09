//
//  Utils.m
//  AC Photo
//
//  Created by noname on 8/6/13.
//  Copyright (c) 2013 test. All rights reserved.
//

#include "Utils.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@implementation Utils

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

- (BOOL)sysVersionEqualTo:(NSString *)version
{
    return SYSTEM_VERSION_EQUAL_TO(version);
}

- (BOOL)sysVersionGreaterThan:(NSString *)version
{
    return SYSTEM_VERSION_GREATER_THAN(version);
}

- (BOOL)sysVersionGreaterThanOrEqualTo:(NSString *)version
{
    return SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version);
}

- (BOOL)sysVersionLessThan:(NSString *)version
{
    return SYSTEM_VERSION_LESS_THAN(version);
}

- (BOOL)sysVersionLessThanOrEqualTo:(NSString *)version
{
    return SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(version);
}

- (int)getNavBarHeight:(int)navBar withStatusbar:(int)statBar
{
    return [self sysVersionGreaterThanOrEqualTo:@"7.0"] ? navBar + statBar : navBar;
}

- (BOOL) animationSlideOut:(UIView *)internetWarning
{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         internetWarning.frame = CGRectMake(0 , 0 - internetWarning.frame.size.height , internetWarning.frame.size.width , internetWarning.frame.size.height );
                     }
                     completion:^(BOOL finished){
                         internetWarning.hidden = YES;
                     }];
    return NO;
}
- (BOOL) animationSlideIn:(UIView *)internetWarning shouldUseiOS7Offset:(BOOL)is7 navBarHeight:(int)navHeight
{
    internetWarning.hidden = NO;
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         internetWarning.frame = CGRectMake(0 , is7 ? navHeight : 0 , internetWarning.frame.size.width , internetWarning.frame.size.height );
                     }
                     completion:^(BOOL finished){
                     }];
    return YES;
}

- (void) animationSlideTableViewIn:(UITableView *)tableView withSliderButton:(UIButton *)sliderButton
                        withCenter:(CGFloat)centerY withMax:(CGFloat)max slideDown:(BOOL) slideDown
                          darkView:(UIView *)darkView alpha:(CGFloat)alpha
{
    CGPoint tableCenter = tableView.center , buttonCenter = sliderButton.center;
    tableCenter.y = centerY;
    buttonCenter.y = max;
    [UIView animateWithDuration:0.3
                               delay:0.0
                             options: UIViewAnimationOptionCurveLinear
                          animations:^{
                              sliderButton.center = buttonCenter;
                              tableView.center = tableCenter;
                              darkView.backgroundColor = RGBA(0 , 0 , 0 , alpha);
                          }
                          completion:^(BOOL finished){
                              if (slideDown)
                              {
                                  tableView.frame = CGRectMake(tableView.frame.origin.x,
                                                               tableView.frame.origin.y,
                                                               tableView.frame.size.width,
                                                               88);
                                  darkView.hidden = YES;
                              }
                          }];
}

@end