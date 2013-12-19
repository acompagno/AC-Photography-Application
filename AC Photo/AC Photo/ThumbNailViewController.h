//
//  ThumbNailViewController.h
//  AC Photo
//
//  Created by noname on 8/4/13.
//  Copyright (c) 2013 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MWPhotoBrowser.h"
#import "Reachability.h"

@interface ThumbNailViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MWPhotoBrowserDelegate>
{
    Reachability *internetReachableGal;
    NSMutableArray *photos;
    AppDelegate *thirdAppDel;
    NSArray *galleryData;
}

@property (nonatomic , retain) UIView *internetAlertGalBackground;
@property (nonatomic , retain) MWPhotoBrowser *photoGallery;
@property (nonatomic , retain) UICollectionView *collectionViewThumbnails;

- (void)testInternetConnection;


@end
