//
//  ThumbNailViewController.m
//  AC Photo
//
//  Created by noname on 8/4/13.
//  Copyright (c) 2013 test. All rights reserved.
//


#import "ThumbNailViewController.h"
#import "CustomCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Resize.h"

#define jsonDataURL [NSURL URLWithString:@"http://www.weebly.com/uploads/6/5/5/1/6551078/acphoto.json"]


@interface ThumbNailViewController ()

@end

@implementation ThumbNailViewController
NSArray *GalleryData;
NSDictionary* json_data;
//MWPhotoBrowser

- (void)viewDidLoad
{
    ThirdAppDel=[[UIApplication sharedApplication]delegate];
    // Do any additional setup after loading the view from its nib.
    NSData* data = [NSData dataWithContentsOfURL:
                    jsonDataURL];
    NSError* error;
    [self setTitle:ThirdAppDel.SecondTableSelection];
    
    json_data = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *gal_name = [NSString stringWithFormat:@"%@_thumbs" , ThirdAppDel.SecondTableSelection];
    
    GalleryData = [json_data objectForKey:gal_name];
    
    NSArray *imageurls = [json_data objectForKey:ThirdAppDel.SecondTableSelection];
    //    [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm4.static.flickr.com/3590/3329114220_5fbc5bc92b.jpg"]]];
    int x;
    for(x = 0 ; x < [imageurls count] ; x++)
    {
        [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.weebly.com/uploads/6/5/5/1/6551078/%@" , imageurls[x]]]]];
    }
    photoGallery = [[MWPhotoBrowser alloc] initWithDelegate:self];
    photoGallery.wantsFullScreenLayout = YES;
    photoGallery.displayActionButton = YES;
    //        [photoGallery setInitialPageIndex:1]; // Example: allows second image to be presented first
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height) collectionViewLayout:layout];
    
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    
    [_collectionView registerClass:[CustomCollectionCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_collectionView setBackgroundColor:[UIColor blackColor]];
    
    [self.view addSubview:_collectionView];
    
    [super viewDidLoad];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [GalleryData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    NSString *url = [NSString stringWithFormat:@"http://andrecphoto.weebly.com/uploads/6/5/5/1/6551078/%@",GalleryData[indexPath.item]];
    
    [cell.imageView setImageWithURL:[NSURL URLWithString:url]
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [cell addGestureRecognizer:tap];
    
    cell.backgroundColor=[UIColor blackColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer  {
    CustomCollectionCell *cell_test = (CustomCollectionCell *)recognizer.view;
    NSIndexPath *indexPath = [_collectionView indexPathForCell:cell_test];
    
    [self.navigationController pushViewController:photoGallery animated:YES];
    
    
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
    //                                                    message:[NSString stringWithFormat:@"index - %d" , indexPath.row]
    //                                                   delegate:nil
    //                                          cancelButtonTitle:@"OK"
    //                                          otherButtonTitles:nil];
    //    [alert show];
    //
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count)
        return [self.photos objectAtIndex:index];
    return nil;
}
@end