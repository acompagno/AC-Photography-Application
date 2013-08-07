//
//  MainViewController.h
//  AC Photo
//
//  Created by noname on 8/4/13.
//  Copyright (c) 2013 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


AppDelegate *MainAppDel;

@interface MainViewController :  UIViewController<UINavigationBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIPageControl *pageControl;
    UIScrollView *scrollViewFeatured;
    UITableView *TableViewMain;
}

@property (nonatomic, retain) IBOutlet UIScrollView* scrollViewFeatured;
@property (nonatomic, retain) IBOutlet UITableView *TableViewMain;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;

@end
