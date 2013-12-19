//
//  SelectionViewController.h
//  AC Photo
//
//  Created by noname on 8/4/13.
//  Copyright (c) 2013 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Reachability.h"

AppDelegate *secondaryAppDel;

@interface SelectionViewController : UIViewController<UINavigationBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    Reachability *internetReachableSel;
    NSArray *tableData2;
    NSString *tempStrHolderSel;
}

@property (nonatomic , retain) UITableView *tableView2;
@property (nonatomic , retain) UIView *internetAlertSelBackground;

- (void)testInternetConnection;

@end

