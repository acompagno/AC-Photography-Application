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

#define jsonDataURL [NSURL URLWithString:@"http://www.weebly.com/uploads/6/5/5/1/6551078/acphoto.json"]


@interface ThumbNailViewController ()

@end

@implementation ThumbNailViewController
NSArray *GalleryData;
NSDictionary* json_data;
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
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height) collectionViewLayout:layout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    
    [_collectionView registerClass:[CustomCollectionCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_collectionView setBackgroundColor:[UIColor blackColor]];
    
    [self.view addSubview:_collectionView];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [GalleryData count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    NSString *url = [NSString stringWithFormat:@"http://andrecphoto.weebly.com/uploads/6/5/5/1/6551078/%@",GalleryData[indexPath.item]];
    
    [cell.imageView setImageWithURL:[NSURL URLWithString:url] andResize:CGSizeMake(100, 100) withContentMode:UIViewContentModeScaleAspectFill];
    
    cell.backgroundColor=[UIColor blackColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
}
@end