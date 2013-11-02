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
#import "FTAnimation+UIView.h"
#import "FTAnimation.h"

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface ThumbNailViewController ()

@end

@implementation ThumbNailViewController

@synthesize collectionViewThumbnails;
@synthesize photos;
@synthesize internetAlertGalBackground;

NSArray *galleryData;
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
     **** **/
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
    
    //iAd Placehoder
    UIView *iAdPlaceholder = [[UIView alloc] initWithFrame:CGRectMake(0 , self.view.bounds.size.height -50 , self.view.bounds.size.width, 50)];
    iAdPlaceholder.backgroundColor=[UIColor redColor];
    
    /*************************
     *Set up internet warning*
     *************************/
    CGRect internetBackgroundFrame = CGRectMake(0 , 60 , self.view.bounds.size.width, 33);
    self.internetAlertGalBackground = [[UIView alloc] initWithFrame:internetBackgroundFrame];
    self.internetAlertGalBackground.backgroundColor = RGBA(204 , 61 , 61 , .90);
    UILabel *yourLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 , 3 , self.view.bounds.size.width , 30)];
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
    self.photos = [NSMutableArray array];
    int x;
    for(x = 0 ; x < [imageurls count] ; x++)
    {
        [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.weebly.com/uploads/6/5/5/1/6551078/%@" , imageurls[x]]]]];
    }
    
    //initialize and set up photobrowser
    photoGallery = [[MWPhotoBrowser alloc] initWithDelegate:self];
    if (photoGallery)
    {
        photoGallery.wantsFullScreenLayout = YES;
        photoGallery.displayActionButton = YES;
    }
    
    /************************
     *Set up collection view*
     ************************/
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    collectionViewThumbnails=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 50) collectionViewLayout:layout];
    if (collectionViewThumbnails && layout)
    {
        [collectionViewThumbnails setDataSource:self];
        [collectionViewThumbnails setDelegate:self];
        [collectionViewThumbnails registerClass:[CustomCollectionCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
        [collectionViewThumbnails setBackgroundColor:[UIColor blackColor]];
        
        [self.view addSubview:collectionViewThumbnails];
        [self.view addSubview:iAdPlaceholder];
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
    
    //Sets up taprecognizer for each cell. (onlcick)
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [cell addGestureRecognizer:tap];
    
    //sets cell's background color to black
    cell.backgroundColor=[UIColor blackColor];
    return cell;
}

//Sets size of cells in the collectionview
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
}

//Sets what happens when a cell in the collectionview is selected (onlclicklistener)
- (void)handleTap:(UITapGestureRecognizer *)recognizer  {
    //gets the cell thats was clicked
    CustomCollectionCell *cell_test = (CustomCollectionCell *)recognizer.view;
    
    //gets indexpath of the cell
    NSIndexPath *indexPath = [collectionViewThumbnails indexPathForCell:cell_test];
    
    if (isConnectedGal)
    {
        //sets the image that will be displayed in the photo browser
        [photoGallery setInitialPageIndex:indexPath.row];
        
        //pushed photobrowser
        [self.navigationController pushViewController:photoGallery animated:YES];
    }
}

#pragma mark - MWPhotoBrowser -
/******************************
*mwphotobrowser delegate stuff*
******************************/
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}
- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count)
        return [self.photos objectAtIndex:index];
    return nil;
}

#pragma mark - Internet -

/***************************
 *Tests internet connection*
 ***************************/

- (void)testInternetConnection
{
    __weak typeof(self) weakSelf = self;
    
    internetReachableGal = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Internet is reachable
    internetReachableGal.reachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            //Removes the warning
            if (! weakSelf.internetAlertGalBackground.hidden)
            {
                [weakSelf.internetAlertGalBackground slideOutTo:kFTAnimationTop duration:.3 delegate:nil];
            }
            //Tells the app that there is now an internet conencton
            isConnectedGal = YES;
            
            //Loads the view if it wants laoded already
            
            [weakSelf.collectionViewThumbnails reloadData];
        });
    };
    
    // Internet is not reachable
    internetReachableGal.unreachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            //Pushes the warning view
            if (![weakSelf.internetAlertGalBackground isDescendantOfView:weakSelf.view])
            {
                [weakSelf.view insertSubview:weakSelf.internetAlertGalBackground aboveSubview:weakSelf.collectionViewThumbnails];
            }
            if (weakSelf.internetAlertGalBackground.hidden)
            {
                [weakSelf.internetAlertGalBackground slideInFrom:kFTAnimationTop duration:.3 delegate:nil];
            }
            isConnectedGal = NO;
        });
    };
    
    [internetReachableGal startNotifier];
}

@end