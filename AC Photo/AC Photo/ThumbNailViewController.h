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

AppDelegate *ThirdAppDel;


@interface ThumbNailViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MWPhotoBrowserDelegate>
{
    UICollectionView *_collectionView;
    MWPhotoBrowser *photoGallery;
}
@property (nonatomic, retain) IBOutlet  NSMutableArray *photos;

@end
