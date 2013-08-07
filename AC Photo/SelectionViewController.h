//
//  SelectionViewController.h
//  AC Photo
//
//  Created by noname on 8/4/13.
//  Copyright (c) 2013 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

AppDelegate *SecondaryAppDel;

@interface SelectionViewController : UIViewController<UINavigationBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UITableView *TableView2;

@end

