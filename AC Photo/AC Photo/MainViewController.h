//
//  MainViewController.h
//  AC Photo
//
//  Created by noname on 8/4/13.
//  Copyright (c) 2013 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Reachability.h"

@interface MainViewController :  UIViewController<UINavigationBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    AppDelegate *mainAppDel;
    Reachability *internetReachableMain;
    NSArray *mainTableData;
    UIBarButtonItem *infoButton;
    NSDictionary *titleOptions;
    CGFloat tableViewStartPoint , maxTableViewScrollPoint;
    BOOL slideOutMenuDemo;
}

@property (nonatomic , retain) UIScrollView* scrollViewFeatured;
@property (nonatomic , retain) UITableView *tableViewMain;
@property (nonatomic , retain) UIPageControl *pageControl;
@property (nonatomic , retain) UIView *infoBackground;
@property (nonatomic , retain) UIView *infoView;
@property (nonatomic , retain) UIView *internetAlertMainBackground;
@property (nonatomic , retain) UIView *darkView;
@property (nonatomic , retain) UIButton *dragTableButton;

- (void)webLaunch:(UIGestureRecognizer *)recognizer;
- (void)fbLaunch:(UIGestureRecognizer *)recognizer;
- (void)infoButtonPressed;
- (void)dismissInfoView;
- (void)loadData;
- (void)testInternetConnection;

@end
