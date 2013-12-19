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
#import "Utils.h"

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define totalWidth ((CGFloat) self.view.bounds.size.width)
#define totalHeight ((CGFloat) self.view.bounds.size.height)
#define isiOS7 ((BOOL) [[Utils alloc] sysVersionGreaterThanOrEqualTo:@"7.0"])
#define navHeight ((int) [[Utils alloc] getNavBarHeight:self.navigationController.navigationBar.frame.size.height withStatusbar:[UIApplication sharedApplication].statusBarFrame.size.height])

@interface ThumbNailViewController ()

@end

@implementation ThumbNailViewController

BOOL didFinishLoadingGal = NO;
BOOL isConnectedGal = NO ;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /**************************
     *Internet connection test*
     **************************/
    [self testInternetConnection];
    
    /******
     *Data*
     ******/
    //Initalize app delegate. used for global variables
    thirdAppDel=[[UIApplication sharedApplication]delegate];
    
    //fetch json data
    NSString *gal_name = [NSString stringWithFormat:@"%@_thumbs" , thirdAppDel.secondTableSelection];
    galleryData = [thirdAppDel.jsonData objectForKey:gal_name];
    NSArray *imageurls = [thirdAppDel.jsonData objectForKey:thirdAppDel.secondTableSelection];
    
    
    /************************
     *Minor view adjustments*
     ************************/
    //Set navigationbar title
    [self setTitle:thirdAppDel.secondTableSelection];
    
    /*************************
     *Set up internet warning*
     *************************/
    self.internetAlertGalBackground = [[UIView alloc] initWithFrame:CGRectMake(0 , -33 , totalWidth , 33)] ;
    self.internetAlertGalBackground.backgroundColor = RGBA(204 , 61 , 61 , .90);
    self.internetAlertGalBackground.hidden = YES ;
    UILabel *yourLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 , 3 , totalWidth , 30)];
    [yourLabel setTextAlignment:NSTextAlignmentCenter];
    [yourLabel setTextColor:[UIColor whiteColor]];
    [yourLabel setBackgroundColor:[UIColor clearColor]];
    [yourLabel setText:@"No Internet Connection"];
    [yourLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [self.internetAlertGalBackground addSubview:yourLabel];
    
    /**********************
     *Set up photo browser*
     **********************/
    //load images for the photobrowser
    photos = [NSMutableArray array];
    int x;
    for(x = 0 ; x < [imageurls count] ; x++)
    {
        [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.weebly.com/uploads/6/5/5/1/6551078/%@" , imageurls[x]]]]];
    }
    
    //initialize and set up photobrowser
    self.photoGallery = [[MWPhotoBrowser alloc] initWithDelegate:self];
    self.photoGallery.navigationController.navigationBar.tintColor = isiOS7 ? RGBA(1,176,129, 1) : nil ;
    if (self.photoGallery)
    {
        self.photoGallery.wantsFullScreenLayout = YES;
        self.photoGallery.displayActionButton = YES;
    }
    
    /************************
     *Set up collection view*
     ************************/
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    
    self.collectionViewThumbnails = isiOS7 ? [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, totalWidth , totalHeight) collectionViewLayout:layout] : [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, totalWidth , totalHeight - navHeight) collectionViewLayout:layout];
    
    if (self.collectionViewThumbnails && layout)
    {
        [self.collectionViewThumbnails setDataSource:self];
        [self.collectionViewThumbnails setDelegate:self];
        [self.collectionViewThumbnails registerClass:[CustomCollectionCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
        [self.collectionViewThumbnails setBackgroundColor:[UIColor blackColor]];
    }
    
    if (self.collectionViewThumbnails && self.internetAlertGalBackground)
    {
        [self.view addSubview:self.collectionViewThumbnails];
        [self.view insertSubview:self.internetAlertGalBackground aboveSubview:self.collectionViewThumbnails];
    }
}

#pragma mark - CollectionView -

/************************
 *CollectionView methods*
 ************************/

//Number of items in the collectionview
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [galleryData count];
}

//Set up what each cell in the collectionview will look like
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //initialize custom cell for the collectionview
    CustomCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    [cell.imageView setClipsToBounds:YES];
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    //format url to load image from
    NSString *url = [NSString stringWithFormat:@"http://andrecphoto.weebly.com/uploads/6/5/5/1/6551078/%@",galleryData[indexPath.item]];
    
    //load thumbnail
    [cell.imageView setImageWithURL:[NSURL URLWithString:url]
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    //sets cell's background color to black
    cell.backgroundColor=[UIColor blackColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES] ;
    if (isConnectedGal)
    {
        //sets the image that will be displayed in the photo browser
        [self.photoGallery setCurrentPhotoIndex:indexPath.row];
        
        //pushed photobrowser
        [self.navigationController pushViewController:self.photoGallery animated:YES];
    }
}

//Sets size of cells in the collectionview
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
}

#pragma mark - MWPhotoBrowser -
/******************************
 *mwphotobrowser delegate stuff*
 ******************************/
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return photos.count;
}
- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < photos.count)
    {
        return [photos objectAtIndex:index];
    }
    return nil;
}

#pragma mark - Internet -

/***************************
 *Tests internet connection*
 ***************************/

- (void)testInternetConnection
{
    __weak typeof(self) weakSelf = self;
    int navHeightTemp = navHeight ;
    internetReachableGal = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Internet is reachable
    internetReachableGal.reachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            //Removes the warning
            if (! weakSelf.internetAlertGalBackground.hidden)
            {
                [[Utils alloc] animationSlideOut:weakSelf.internetAlertGalBackground];
            }
            //Tells the app that there is now an internet conencton
            isConnectedGal = YES;
            
            //Loads the view if it wants laoded already
            
            [weakSelf.self.collectionViewThumbnails reloadData];
        });
    };
    
    // Internet is not reachable
    internetReachableGal.unreachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            //Pushes the warning view
            if (weakSelf.internetAlertGalBackground.hidden)
            {
                [[Utils alloc] animationSlideIn:weakSelf.internetAlertGalBackground shouldUseiOS7Offset:isiOS7 navBarHeight:navHeightTemp];
            }
            isConnectedGal = NO;
        });
    };
    
    [internetReachableGal startNotifier];
}

@end