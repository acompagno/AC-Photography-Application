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
AppDelegate *thirdAppDel;


@interface ThumbNailViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MWPhotoBrowserDelegate>
{
    Reachability *internetReachableGal;
    UICollectionView *collectionViewThumbnails;
    MWPhotoBrowser *photoGallery;
    UIView *internetAlertGalBackground;
}

@property (nonatomic , retain) NSMutableArray *photos;
@property (nonatomic , retain) UIView *internetAlertGalBackground;
@property (nonatomic , retain) UICollectionView *collectionViewThumbnails;

@end
