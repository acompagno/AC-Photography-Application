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
#include <string.h>
#import <QuartzCore/QuartzCore.h>

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define jsonDataURL [NSURL URLWithString:@"http://www.weebly.com/uploads/6/5/5/1/6551078/acphoto.json"]

#define totalWidth ((CGFloat) self.view.bounds.size.width)
#define totalHeight ((CGFloat) self.view.bounds.size.height)
#define isiOS7 ((BOOL) [[Utils alloc] sysVersionGreaterThanOrEqualTo:@"7.0"])
#define navHeight ((int) [[Utils alloc] getNavBarHeight:self.navigationController.navigationBar.frame.size.height withStatusbar:[UIApplication sharedApplication].statusBarFrame.size.height])

@interface MainViewController ()
@end

@implementation MainViewController

BOOL didFinishLoading = NO;
BOOL isConnected = NO ;

- (void)viewDidLoad
{
    /****************************************************************************************
     *Set this value to YES to enable the Slide out menu demo.                              *
     *This demo enables the caterogires slide out menu by creating dummy tableview cells    *
     ****************************************************************************************/
    slideOutMenuDemo = YES;
    
    [super viewDidLoad];
    
    /**************************
     *Internet connection test*
     **************************/
    [self testInternetConnection];
    
    if (isiOS7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        
    }
    
    /**********************
     *Set up navigationbar*
     **********************/
    //Set the title of the navigationbar
    [self setTitle:@"Featured"];
    //Set the background color of the view
    self.view.backgroundColor = RGBA(224, 224 , 224, 1);
    //set the tintcolor for the navigationbar
    self.navigationController.navigationBar.tintColor = RGBA(1,176,129, 1);
    //if version < ios7 set the color of the navigationbar
    !(isiOS7) ?[self.navigationController.navigationBar setBackgroundImage:[[[Utils alloc] init] imageWithColor:RGBA(1,176,129 , 1)] forBarMetrics:UIBarMetricsDefault] : nil;
    
    //Nsdictionary used for switching the title of the view when clocking the info button
    titleOptions = @{@"Featured" : @"Info" , @"Info" : @"Featured"} ;
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
    
    /*************************
     *Set up internet warning*
     *************************/
    self.internetAlertMainBackground = [[UIView alloc] initWithFrame:CGRectMake(0 , -33 , totalWidth , 33)];
    self.internetAlertMainBackground.backgroundColor = RGBA(204 , 61 , 61 , .90);
    self.internetAlertMainBackground.hidden = YES;
    UILabel *internetWarningText = [[UILabel alloc] initWithFrame:CGRectMake(0 , 3 , totalWidth , 30)];
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
    self.infoView = [[UIView alloc] initWithFrame:CGRectMake(30 , (totalHeight - navHeight - 234)/2 , totalWidth - 60,  234)];
    self.infoView.backgroundColor = [UIColor whiteColor];
    self.infoBackground = [[UIView alloc] initWithFrame:CGRectMake(0 , 0 , totalWidth,  totalHeight)];
    self.infoBackground.backgroundColor = RGBA(0, 0, 0, .7);
    self.infoBackground.hidden = YES ;
    self.infoView.hidden = YES ;
    //set upthe gesture recognizer which will dismiss the infoview when clicking off the view
    UITapGestureRecognizer *dismissInfoGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissInfoView)];
    //Add the gesture recognizer to the tepView
    [self.infoBackground addGestureRecognizer:dismissInfoGesture];
    
    //Set up the Facebook button and text
    UIImageView *fbButtonImg = [[UIImageView alloc]initWithFrame:CGRectMake(10 , 15 , 50 , 50)];
    [fbButtonImg setImage:[UIImage imageNamed:@"FBLogo.png"]];
    [fbButtonImg setUserInteractionEnabled:YES];
    UITapGestureRecognizer *fbButton =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fbLaunch:)];
    [fbButton setNumberOfTapsRequired:1];
    [fbButtonImg addGestureRecognizer:fbButton];
    UILabel *fbText = [[UILabel alloc] initWithFrame:CGRectMake(59 , 15 , totalWidth-60-15-50 , 50)];
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
    UILabel *webText = [[UILabel alloc] initWithFrame:CGRectMake(59 , 80 , totalWidth - 60 - 15 - 50 , 50)];
    [webText setTextAlignment:NSTextAlignmentCenter];
    webText.lineBreakMode = NSLineBreakByWordWrapping;
    webText.numberOfLines = 2;
    [webText setTextColor:[UIColor blackColor]];
    [webText setBackgroundColor:[UIColor clearColor]];
    [webText setFont:[UIFont fontWithName:@"Avenir-LightOblique" size:15]];
    [webText setText:@"Visit the AndreCompagno Photography website"];
    
    //Set up application information text
    UILabel *infoText = [[UILabel alloc] initWithFrame:CGRectMake(0 , 145 , totalWidth-60 , 80)];
    [infoText setTextAlignment:NSTextAlignmentCenter];
    infoText.lineBreakMode = NSLineBreakByWordWrapping;
    infoText.numberOfLines = 0;
    [infoText setTextColor:[UIColor blackColor]];
    [infoText setBackgroundColor:[UIColor clearColor]];
    [infoText setFont:[UIFont fontWithName:@"Avenir-LightOblique" size:15]];
    [infoText setText:@"App Details\nVersion - 1.0\nDeveloper - Andre Compagno"];
    
    //Add all the views into the information view
    if (fbButtonImg && fbText && webButtonImg && webText && infoText)
    {
        [self.infoView addSubview:fbButtonImg];
        [self.infoView addSubview:fbText];
        [self.infoView addSubview:webButtonImg];
        [self.infoView addSubview:webText];
        [self.infoView addSubview:infoText];
    }
    
    //Initalize app delegate. used for global variables
    mainAppDel = [[UIApplication sharedApplication]delegate];
    
    /***********************************
     *Set up featured images scrollView*
     ***********************************/
    //Set up scrollview to display featured images
    self.scrollViewFeatured = [[UIScrollView alloc] init];
    if (self.scrollViewFeatured)
    {
        self.scrollViewFeatured.frame = CGRectMake(0 , 0 , totalWidth , totalHeight - navHeight - 88);
        [self.scrollViewFeatured setPagingEnabled:YES];
        self.scrollViewFeatured.contentSize = CGSizeMake(self.scrollViewFeatured.frame.size.width * 5, self.scrollViewFeatured.frame.size.height);
        self.scrollViewFeatured.backgroundColor = RGBA(0, 0, 0, .75);
        self.scrollViewFeatured.delegate = self;
        self.scrollViewFeatured.showsHorizontalScrollIndicator=NO;
    }
    
    // Set up pagecontrol to use with the scrollview
    self.pageControl = [[UIPageControl alloc] init];
    if (self.pageControl)
    {
        self.pageControl.frame = CGRectMake( 0, 5 , totalWidth , 15);
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
        self.tableViewMain.frame = CGRectMake(0 , self.scrollViewFeatured.frame.size.height , totalWidth , 88);
        self.tableViewMain.dataSource = self;
        self.tableViewMain.delegate = self;
        self.tableViewMain.backgroundColor = [UIColor whiteColor];
        self.tableViewMain.scrollEnabled = NO;
        [self.tableViewMain setSeparatorColor:[UIColor lightGrayColor]];
        isiOS7 ? [self.tableViewMain setSeparatorInset:UIEdgeInsetsZero] : nil;
        [self.tableViewMain reloadData];
    }
    
    self.darkView = [[UIView alloc] initWithFrame:CGRectMake(0 , 0 , totalWidth , totalHeight)];
    if (self.darkView)
    {
        self.darkView.backgroundColor = RGBA(0 , 0 , 0 , 0);
        self.darkView.hidden = YES;
    }
    
    self.dragTableButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.dragTableButton)
    {
        self.dragTableButton.frame = CGRectMake((totalWidth - 50) / 2, self.scrollViewFeatured.frame.size.height - 15 , 50, 15);
        [self.dragTableButton setImage:[UIImage imageNamed:@"drag_up.png"] forState:UIControlStateNormal];
        [self.dragTableButton addTarget:self action:@selector(imageTouch:withEvent:) forControlEvents:UIControlEventTouchDownRepeat];
        [self.dragTableButton addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
        tableViewStartPoint = self.dragTableButton.center.y;
        self.dragTableButton.hidden = YES;
    }
    /***************
     *Add all views*
     ***************/
    if (self.scrollViewFeatured && self.pageControl && self.tableViewMain && self.infoView && self.infoBackground)
    {
        [self.view addSubview:self.scrollViewFeatured ];
        //Page controler gets added above the scrollview not inside it
        [self.view insertSubview:self.pageControl aboveSubview:self.scrollViewFeatured];
        [self.view addSubview:self.infoBackground];
        [self.view addSubview:self.infoView];
        [self.view insertSubview:self.internetAlertMainBackground aboveSubview:self.pageControl];
        [self.view insertSubview:self.darkView aboveSubview:self.internetAlertMainBackground];
        [self.view insertSubview:self.tableViewMain aboveSubview:self.darkView];
        [self.view insertSubview:self.dragTableButton aboveSubview:self.darkView];
    }
}


- (IBAction) imageTouch:(id) sender withEvent:(UIEvent *) event
{
    UIControl *control = sender;
    if (control.center.y <= tableViewStartPoint && control.center.y >= (maxTableViewScrollPoint+tableViewStartPoint)/2)
    {
        self.tableViewMain.frame = CGRectMake(self.tableViewMain.frame.origin.x, self.tableViewMain.frame.origin.y,
                                              self.tableViewMain.frame.size.width, totalHeight - maxTableViewScrollPoint - (15/2));
        [[Utils alloc] animationSlideTableViewIn:self.tableViewMain
                                withSliderButton:(UIButton *)control
                                      withCenter:self.tableViewMain.center.y + maxTableViewScrollPoint - control.center.y
                                         withMax:maxTableViewScrollPoint
                                       slideDown:NO
                                        darkView:self.darkView
                                           alpha:(tableViewStartPoint - maxTableViewScrollPoint) / tableViewStartPoint];
        
        self.darkView.backgroundColor = RGBA(0, 0, 0,(tableViewStartPoint - maxTableViewScrollPoint) / tableViewStartPoint);
        self.darkView.hidden = NO;
        [self setTitle:@"Categories"];
        [self.dragTableButton setImage:[UIImage imageNamed:@"drag_down.png"] forState:UIControlStateNormal];
        
    }
    else if (control.center.y >= maxTableViewScrollPoint && control.center.y < (maxTableViewScrollPoint+tableViewStartPoint)/2)
    {
        [[Utils alloc] animationSlideTableViewIn:self.tableViewMain
                                withSliderButton:(UIButton *)control
                                      withCenter:self.tableViewMain.center.y + tableViewStartPoint - control.center.y
                                         withMax:tableViewStartPoint
                                       slideDown:YES
                                        darkView:self.darkView
                                           alpha:0];
        [self.dragTableButton setImage:[UIImage imageNamed:@"drag_up.png"] forState:UIControlStateNormal];
        [self setTitle:@"Featured"];
    }
}

- (IBAction) imageMoved:(id) sender withEvent:(UIEvent *) event
{
    UIControl *control = sender;
    
    UITouch *t = [[event allTouches] anyObject];
    CGPoint pPrev = [t previousLocationInView:control];
    CGPoint p = [t locationInView:control];
    
    CGPoint tableCenter = self.tableViewMain.center;
    CGPoint center = control.center;
    if (center.y + p.y - pPrev.y > maxTableViewScrollPoint && center.y + p.y - pPrev.y < tableViewStartPoint)
    {
        center.y += p.y - pPrev.y;
        tableCenter.y += p.y - pPrev.y;
        control.center = center;
        self.tableViewMain.center = tableCenter;
        self.tableViewMain.frame = CGRectMake(self.tableViewMain.frame.origin.x, self.tableViewMain.frame.origin.y,
                                              self.tableViewMain.frame.size.width, totalHeight - control.center.y - (15/2));
        self.darkView.backgroundColor = RGBA(0, 0, 0,   (tableViewStartPoint - control.center.y) / (tableViewStartPoint));
    }
    
    self.darkView.hidden = tableViewStartPoint - control.center.y < 30;
    self.darkView.hidden ? [self setTitle:@"Featured"] : [self setTitle:@"Categories"];
    
    if (control.center.y <= tableViewStartPoint && control.center.y >= (maxTableViewScrollPoint+tableViewStartPoint)/2)
        [self.dragTableButton setImage:[UIImage imageNamed:@"drag_up.png"] forState:UIControlStateNormal];
    else if (control.center.y >= maxTableViewScrollPoint && control.center.y < (maxTableViewScrollPoint+tableViewStartPoint)/2)
        [self.dragTableButton setImage:[UIImage imageNamed:@"drag_down.png"] forState:UIControlStateNormal];

    
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
        NSURL *url = [NSURL URLWithString:@"fb://profile/239468832773903"];
        
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }
        else
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/pages/AndreCompagno-Photography/239468832773903"]];
        }
    }
}

/* *********************************************
 *Loads or closes the information view          *
 *Called when the information button is pressed*
 ***********************************************/
-(void)infoButtonPressed
{
    self.infoBackground.hidden = !self.infoBackground.hidden ;
    self.infoView.hidden = !self.infoView.hidden ;
    [self setTitle:[titleOptions objectForKey:self.title]];
}

/********************************************************
 *Loads or closes the information view                  *
 *Called when the information background view is clicked*
 ********************************************************/
-(void)dismissInfoView
{
    [self infoButtonPressed];
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
        mainTableData = slideOutMenuDemo ?  @[@"table cell1",
                                              @"table cell2",
                                              @"table cell3",
                                              @"table cell4",
                                              @"table cell5",
                                              @"table cell6",
                                              @"table cell7",
                                              @"table cell8",
                                              @"table cell9",
                                              @"table cell10"]:
        [mainAppDel.jsonData objectForKey:@"main_page"];
        
        self.tableViewMain.scrollEnabled = [mainTableData count] > 2;
        self.dragTableButton.hidden = [mainTableData count] <= 2 ;
    }
    
    maxTableViewScrollPoint = (totalHeight - [mainTableData count] * [self.tableViewMain rowHeight] > totalHeight / 4) ? totalHeight - [mainTableData count] * [self.tableViewMain rowHeight] : totalHeight / 4;
    //offset
    maxTableViewScrollPoint -= 15/2;
    
    NSArray *featured;
    
    //Fetch json data for featured images
    featured = [mainAppDel.jsonData objectForKey:@"Featured"];
    
    CGFloat x=0;
    for(int i=1;i<6;i++)
    {
        UIImageView *image = [[UIImageView alloc] init];
        image.frame = CGRectMake(0+x, 0, 320, self.scrollViewFeatured.bounds.size.height);
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
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    //Set the text from the json data
    cell.textLabel.text = [NSString stringWithFormat:@"%@" , [mainTableData objectAtIndex:indexPath.row]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[Utils alloc] imageWithColor:RGBA(9 , 277 , 122 , 1)]];
    cell.textLabel.highlightedTextColor = [UIColor whiteColor];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mainTableData count];
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
    self.pageControl.currentPage = page;
}

#pragma mark - Internet -

/***************************
 *Tests internet connection*
 ***************************/
- (void)testInternetConnection
{
    __weak typeof(self) weakSelf = self;
    int navHeightTemp = navHeight;
    //Sets up the warning
    internetReachableMain = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Internet is reachable
    internetReachableMain.reachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            //Removes the warning
            if (!weakSelf.internetAlertMainBackground.hidden)
            {
                [[Utils alloc] animationSlideOut:weakSelf.internetAlertMainBackground];
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
            if (weakSelf.internetAlertMainBackground.hidden)
            {
                [[Utils alloc] animationSlideIn:weakSelf.internetAlertMainBackground shouldUseiOS7Offset:NO navBarHeight:navHeightTemp];
            }
            isConnected = NO;
        });
    };
    
    [internetReachableMain startNotifier];
}

@end
