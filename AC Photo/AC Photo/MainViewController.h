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
#import "iAd/ADBannerView.h"

AppDelegate *mainAppDel;

@interface MainViewController :  UIViewController<UINavigationBarDelegate,UITableViewDelegate,UITableViewDataSource,ADBannerViewDelegate>
{
    UIPageControl *pageControl;
    UIScrollView *scrollViewFeatured;
    UITableView *tableViewMain;
    Reachability *internetReachableMain;
    UIView *infoBackground;
    UIView *infoView;
    UIView *internetAlertMainBackground;
}

@property (nonatomic , retain) UIScrollView* scrollViewFeatured;
@property (nonatomic , retain) UITableView *tableViewMain;
@property (nonatomic , retain) UIPageControl *pageControl;
@property (nonatomic , retain) UIView *infoBackground;
@property (nonatomic , retain) UIView *infoView;
@property (nonatomic , retain) UIView *internetAlertMainBackground;

@end
