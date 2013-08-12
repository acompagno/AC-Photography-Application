//
//  MainViewController.m
//  AC Photo
//
//  Created by noname on 8/4/13.
//  Copyright (c) 2013 test. All rights reserved.
//

#import "MainViewController.h"
#import "SelectionViewController.h"
#import "UIImageView+WebCache.h"
#import "Utils.h"
#import "FTAnimation+UIView.h"
#import "FTAnimation.h"
#import "iAd/ADBannerView.h"
#include <string.h>

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define jsonDataURL [NSURL URLWithString:@"http://www.weebly.com/uploads/6/5/5/1/6551078/acphoto.json"]

@interface MainViewController ()
@end

@implementation MainViewController

@synthesize scrollViewFeatured;
@synthesize tableViewMain;
@synthesize pageControl;
@synthesize infoBackground;
@synthesize infoView;
@synthesize internetAlertMainBackground;

NSArray *mainTableData;
BOOL didFinishLoading = NO;
BOOL isConnected = NO ;
UIBarButtonItem *infoButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /**************************
     *Internet connection test*
     **************************/
    [self testInternetConnection];

    /**********************
     *Set up navigationbar*
     **********************/
    //Set the title of the navigationbar
    [self setTitle:@"Featured"];

    //Set the Color of the navigationbar
    self.view.backgroundColor = RGBA(224, 224,224, 1);
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    [self.navigationController.navigationBar setTintColor:RGBA(1,176,129, 1)];
    [self.navigationController.navigationBar setBackgroundImage:[[[Utils alloc] init] imageWithColor:RGBA(1,176,129 , 1)]
                                                  forBarMetrics:UIBarMetricsDefault];
    //Create info button in navigation bar
    UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [button addTarget:self action:@selector(infoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    infoButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    if (infoButton)
    {
        self.navigationItem.rightBarButtonItem = infoButton;
    }
    
    /**********************************************************
     *Loads all the data for the view                         *
     *Is only called if there is an active internet connection*
     **********************************************************/
    if (isConnected)
    {
        [self loadData];
        didFinishLoading = YES;
    }
    
    //AdView PlaceHolder
    UIView *iAdPlaceholder = [[UIView alloc] initWithFrame:CGRectMake(0 , self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height-50 , self.view.bounds.size.width, 50)];
    iAdPlaceholder.backgroundColor=[UIColor redColor];
    
    /*************************
     *Set up internet warning*
     *************************/
    CGRect internetBackgroundFrame = CGRectMake(0 , 0 , self.view.bounds.size.width, 33);
    self.internetAlertMainBackground = [[UIView alloc] initWithFrame:internetBackgroundFrame];
    self.internetAlertMainBackground.backgroundColor = RGBA(204 , 61 , 61 , .90);
    UILabel *internetWarningText = [[UILabel alloc] initWithFrame:CGRectMake(0 , 0 , self.view.bounds.size.width , 30)];
    [internetWarningText setTextAlignment:NSTextAlignmentCenter];
    [internetWarningText setTextColor:[UIColor whiteColor]];
    [internetWarningText setBackgroundColor:[UIColor clearColor]];
    [internetWarningText setText:@"No Internet Connection"];
    [internetWarningText setFont:[UIFont boldSystemFontOfSize:15]];
    [self.internetAlertMainBackground addSubview:internetWarningText];

    /******************
     *Set up info View*
     ******************/
    //Set up content view and background
    self.infoView = [[UIView alloc] initWithFrame:CGRectMake(30 , (self.view.bounds.size.height-self.navigationController.navigationBar.frame.size.height-234)/2 , self.view.bounds.size.width-60,  234)];
    self.infoView.backgroundColor = [UIColor whiteColor];
    self.infoBackground = [[UIView alloc] initWithFrame:CGRectMake(0 , 0 , self.view.bounds.size.width,  self.view.bounds.size.height)];
    self.infoBackground.backgroundColor = RGBA(0, 0, 0, .7);
    
    //Set up the Facebook button and text
    UIImageView *fbButtonImg = [[UIImageView alloc]initWithFrame:CGRectMake(10 , 15 , 50 , 50 )];
    [fbButtonImg setImage:[UIImage imageNamed:@"FBLogo.png"]];
    [fbButtonImg setUserInteractionEnabled:YES];
    UITapGestureRecognizer *fbButton =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fbLaunch:)];
    [fbButton setNumberOfTapsRequired:1];
    [fbButtonImg addGestureRecognizer:fbButton];
    UILabel *fbText = [[UILabel alloc] initWithFrame:CGRectMake(59 , 20 , self.view.bounds.size.width-60-15-50 , 40)];
    [fbText setTextAlignment:NSTextAlignmentCenter];
    fbText.lineBreakMode = NSLineBreakByWordWrapping;
    fbText.numberOfLines = 2;
    [fbText setTextColor:[UIColor blackColor]];
    [fbText setBackgroundColor:[UIColor clearColor]];
    [fbText setFont:[UIFont fontWithName:@"Avenir-LightOblique" size:15]];
    [fbText setText:@"Check out AndreCompagno Photography on Facebook"];
    
    //Set up website button and text
    UIImageView *webButtonImg = [[UIImageView alloc]initWithFrame:CGRectMake(10 , 80 , 50 , 50 )];
    [webButtonImg setImage:[UIImage imageNamed:@"WebsiteButton.png"]];
    [webButtonImg setUserInteractionEnabled:YES];
    UITapGestureRecognizer *webButton =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(webLaunch:)];
    [webButton setNumberOfTapsRequired:1];
    [webButtonImg addGestureRecognizer:webButton];
    UILabel *webText = [[UILabel alloc] initWithFrame:CGRectMake(59 , 85 , self.view.bounds.size.width-60-15-50 , 40)];
    [webText setTextAlignment:NSTextAlignmentCenter];
    webText.lineBreakMode = NSLineBreakByWordWrapping;
    webText.numberOfLines = 2;
    [webText setTextColor:[UIColor blackColor]];
    [webText setBackgroundColor:[UIColor clearColor]];
    [webText setFont:[UIFont fontWithName:@"Avenir-LightOblique" size:15]];
    [webText setText:@"Visit the AndreCompagno Photography website"];
    
    //Set up application information text
    UILabel *infoText = [[UILabel alloc] initWithFrame:CGRectMake(0 , 160 , self.view.bounds.size.width-60 , 60)];
    [infoText setTextAlignment:NSTextAlignmentCenter];
    infoText.lineBreakMode = NSLineBreakByWordWrapping;
    infoText.numberOfLines = 0;
    [infoText setTextColor:[UIColor blackColor]];
    [infoText setBackgroundColor:[UIColor clearColor]];
    [infoText setFont:[UIFont fontWithName:@"Avenir-LightOblique" size:15]];
    [infoText setText:@"App Details\nVersion - 1.0\nDeveloper - Andre Compagno"];
    
    //Add all the views into the information view
    [self.infoView addSubview:fbButtonImg];
    [self.infoView addSubview:fbText];
    [self.infoView addSubview:webButtonImg];
    [self.infoView addSubview:webText];
    [self.infoView addSubview:infoText];
    
    //Initalize app delegate. used for global variables
    mainAppDel=[[UIApplication sharedApplication]delegate];
    
    /***********************************
     *Set up featured images scrollView*
     ***********************************/
    //Set up scrollview to display featured images
    self.scrollViewFeatured = [[UIScrollView alloc] init];
    if (self.scrollViewFeatured)
    {
        self.scrollViewFeatured.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50 - 44 - 88);
        [self.scrollViewFeatured setPagingEnabled:YES];
        self.scrollViewFeatured.contentSize = CGSizeMake(self.scrollViewFeatured.frame.size.width*5, self.scrollViewFeatured.frame.size.height);
        self.scrollViewFeatured.backgroundColor = RGBA(0, 0, 0, .75);
        self.scrollViewFeatured.delegate = self;
        self.scrollViewFeatured.showsHorizontalScrollIndicator=NO;
    }

    // Set up pagecontrol to use with the scrollview
    self.pageControl = [[UIPageControl alloc] init];
    if (self.pageControl)
    {
        self.pageControl.frame = CGRectMake( 0, 0, self.view.bounds.size.width, 15);
        [self.pageControl setNumberOfPages:5];
        [self.pageControl setCurrentPage:0];
        [self.pageControl setBackgroundColor:[UIColor clearColor]];
    }
    
    /******************
     *Set up TableView*
     ******************/
    self.tableViewMain = [[UITableView alloc] init];
    if (self.tableViewMain)
    {
        self.tableViewMain .frame = CGRectMake(0  , self.scrollViewFeatured.frame.size.height , self.view.bounds.size.width, 88);
        
        self.tableViewMain.dataSource = self;
        self.tableViewMain.delegate = self;
        self.tableViewMain.backgroundColor = [UIColor clearColor];
        self.tableViewMain.scrollEnabled = NO;
        [self.tableViewMain setSeparatorColor:[UIColor lightGrayColor]];
        
        [self.tableViewMain reloadData];
    }
    
    /***************
     *Add all views*
     ***************/
    if (self.scrollViewFeatured && self.pageControl && self.tableViewMain)
    {
        [self.view addSubview:self.scrollViewFeatured ];
        [self.view addSubview:iAdPlaceholder];
        [self.view addSubview:self.tableViewMain];
        //Page controle gets added above the scrollview not inside it 
        [self.view insertSubview:self.pageControl aboveSubview:self.scrollViewFeatured];
    }
}

#pragma mark - Button Methods -
/********************************************************
 *Loads the website in the safari web browser           *
 *Called when the website icon is clicked               *
 *Only works when there is an active internet connection*
 ********************************************************/
-(void)webLaunch:(UIGestureRecognizer *)recognizer
{
    if (isConnected)
    {        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://andrecphoto.weebly.com/"]];
    }
}

/************************************************************************
 *Loads the facebook page in the facebook app or the  safari web browser*
 *Called when the facebook icon is clicked                              *
 *Only works when there is an active internet connection                *
 ************************************************************************/
-(void)fbLaunch:(UIGestureRecognizer *)recognizer
{
    if (isConnected)
    {
        NSURL *url = [NSURL URLWithString:@"fb://profile/<239468832773903>"];
        
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
        else
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/pages/AndreCompagno-Photography/239468832773903"]];
        }
    }
}

//Info button action
-(IBAction)infoButtonPressed
{
    //if info view is visible
    if ([self.infoView isDescendantOfView:self.view] && [self.infoBackground isDescendantOfView:self.view])
    {
        [self.infoBackground removeFromSuperview];
        [self.infoView removeFromSuperview];
        [self setTitle:@"Featured"];
    }
    //if info view is not visible
    else if (![self.infoView isDescendantOfView:self.view] && ![self.infoBackground isDescendantOfView:self.view])
    {
        [self.view insertSubview:self.infoBackground aboveSubview:self.view];
        [self.view insertSubview:self.infoView aboveSubview:self.infoBackground];
        [self setTitle:@"Info"];
    }
}

#pragma mark - Load Data -

/*******************************************
 *Loads all the data for the viewcontroller*
 *******************************************/
-(void)loadData
{
    //Fetch json data
    mainAppDel.data = [NSData dataWithContentsOfURL:
                       jsonDataURL];
    NSError *error;
    if (mainAppDel.data)
    {
        mainAppDel.jsonData = [NSJSONSerialization JSONObjectWithData:mainAppDel.data options:kNilOptions error:&error];
        mainTableData = [mainAppDel.jsonData objectForKey:@"main_page"];
    }
    
    NSArray *featured;
    
    //Fetch json data for featured images
    featured = [mainAppDel.jsonData objectForKey:@"Featured"];
    
    CGFloat x=0;
    for(int i=1;i<6;i++)
    {
        UIImageView *image = [[UIImageView alloc] init];
        image.frame = CGRectMake(0+x, 0, 320, self.scrollViewFeatured.frame.size.height);
        [image setClipsToBounds:YES];
        image.contentMode = UIViewContentModeScaleAspectFill;
        [image setImageWithURL:[NSURL URLWithString:featured[i-1]]];
        if (image)
        {
            [self.scrollViewFeatured addSubview:image];
        }
        x+=320;
    }
    [self.tableViewMain reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mainTableData count];
}

#pragma mark - TableView -

/******************
*Tableview Methods*
*******************/
//Sets what each cell is going to look like in the tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    //Initialize cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    //Set the text from the json data
    cell.textLabel.text = [NSString stringWithFormat:@"%@" , [mainTableData objectAtIndex:indexPath.row]];
    
    //Set the background images for the cells
    //    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellBackgroundMain.png"]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellBackgroundMainClick.png"]];
    
    return cell;
}

//Sets number of sections in the tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//Sets what happens when a cell in the tableview is selected (onlclicklistener)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Set global variable. Stores the selection from the tableview
    mainAppDel.rootTableSelection = mainTableData[indexPath.row];
    
    //Deselect cell after its clicked
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //Pushes to Slectionviewcontroller
    SelectionViewController *selectionView=[[SelectionViewController alloc] init];
    
    if (selectionView)
    {
        [self.navigationController pushViewController:selectionView animated:YES];
    }
}

#pragma mark - Page Control -

/*********************
 *Pagecontrol Methods*
 *********************/
//Sets the Pagecontrol when the scrollview is scrolled
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = self.scrollViewFeatured.contentOffset.x/self.scrollViewFeatured.frame.size.width;
    pageControl.currentPage = page;
}

#pragma mark - Internet -

/***************************
 *Tests internet connection*
 ***************************/
- (void)testInternetConnection
{
    __weak typeof(self) weakSelf = self;
    //Sets up the warning
    internetReachableMain = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Internet is reachable
    internetReachableMain.reachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            //Removes the warning
            if (! weakSelf.internetAlertMainBackground.hidden)
            {
                [weakSelf.internetAlertMainBackground slideOutTo:kFTAnimationTop duration:.3 delegate:nil];
            }
            
            //Tells the app that there is now an internet conencton
            isConnected = YES;
            
            //Loads the view if it wasnt loaded already
            if (!didFinishLoading)
            {
                [weakSelf loadData];
            }
        });
    };
    
    // Internet is not reachable
    internetReachableMain.unreachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            //Pushes the warning view
            if (![weakSelf.internetAlertMainBackground isDescendantOfView:weakSelf.view])
            {
                [weakSelf.view insertSubview:weakSelf.internetAlertMainBackground aboveSubview:weakSelf.pageControl];
            }
            if (weakSelf.internetAlertMainBackground.hidden)
            {
                [weakSelf.internetAlertMainBackground slideInFrom:kFTAnimationTop duration:.3 delegate:nil];
            }
            isConnected = NO;
        });
    };
    
    [internetReachableMain startNotifier];
}
@end
