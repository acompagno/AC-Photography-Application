//
//  AppDelegate.h
//  AC Photo
//
//  Created by noname on 8/4/13.
//  Copyright (c) 2013 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString *RootTableSelection;
    NSString *SecondTableSelection;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UINavigationController *navController;
@property(nonatomic,retain) NSString *RootTableSelection;
@property(nonatomic,retain) NSString *SecondTableSelection;

@end
