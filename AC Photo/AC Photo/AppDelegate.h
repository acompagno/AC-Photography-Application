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
    NSString *rootTableSelection;
    NSString *secondTableSelection;
    NSData *data;
    NSDictionary *jsonData;
}

@property (nonatomic , retain) UIWindow *window;
@property (nonatomic , retain) UINavigationController *navController;
@property (nonatomic , retain) NSString *rootTableSelection;
@property (nonatomic , retain) NSString *secondTableSelection;
@property (nonatomic , retain) NSData *data;
@property (nonatomic , retain) NSDictionary *jsonData;

@end
