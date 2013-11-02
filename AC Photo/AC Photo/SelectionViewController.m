//
//  SelectionViewController.m
//  AC Photo
//
//  Created by noname on 8/4/13.
//  Copyright (c) 2013 test. All rights reserved.
//

#import "SelectionViewController.h"
#import "ThumbNailViewController.h"
#import "CustomTableCell.h"
#import "UIImageView+WebCache.h"
#import "Utils.h"
#import "FTAnimation+UIView.h"
#import "FTAnimation.h"


#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


@interface SelectionViewController ()
@end

@implementation SelectionViewController

@synthesize tableView2;
@synthesize internetAlertSelBackground;

NSArray *tableData2;
BOOL didFinishLoadingSel = NO;
BOOL isConnectedSel = NO ;
NSString *tempStrHolderSel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /**************************
     *Internet connection test*
     **************************/
    [self testInternetConnection];
    
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    //Initalize app delegate. used for global variables
    secondaryAppDel=[[UIApplication sharedApplication]delegate];
    //Load json data
    tableData2 = [secondaryAppDel.jsonData objectForKey:secondaryAppDel.rootTableSelection];
    
    /************************
     *Minor view adjustments*
     ************************/
    //Set the title of the navigationbar
    [self setTitle:secondaryAppDel.rootTableSelection];
    //Set background Color
    self.view.backgroundColor = RGBA(224, 224,224, 1);
    
    //iAd Placehoder
    UIView *iAdPlaceholder = [[UIView alloc] initWithFrame:CGRectMake(0 , self.view.bounds.size.height -50 , self.view.bounds.size.width, 50)];
    iAdPlaceholder.backgroundColor=[UIColor redColor];
    /*************************
     *Set up internet warning*
     *************************/
    CGRect internetBackgroundFrame = CGRectMake(0 , 60 , self.view.bounds.size.width, 33);
    self.internetAlertSelBackground = [[UIView alloc] initWithFrame:internetBackgroundFrame];
    self.internetAlertSelBackground.backgroundColor = RGBA(204 , 61 , 61 , .90);
    UILabel *yourLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 , 3 , self.view.bounds.size.width , 30)];
    [yourLabel setTextAlignment:NSTextAlignmentCenter];
    [yourLabel setTextColor:[UIColor whiteColor]];
    [yourLabel setBackgroundColor:[UIColor clearColor]];
    [yourLabel setText:@"No Internet Connection"];
    [yourLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [self.internetAlertSelBackground addSubview:yourLabel];
    
    /******************
     *Set up TableView*
     ******************/
    self.tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50)];
    
    if (tableView2)
    {
        self.tableView2.dataSource = self;
        self.tableView2.delegate = self;
        self.tableView2.backgroundColor = RGBA(224, 224,224, 1);
        [self.tableView2 setSeparatorColor:[UIColor clearColor]];
        [self.tableView2 reloadData];
        
        //Add Views
        [self.view addSubview:self.tableView2];
        [self.view addSubview:iAdPlaceholder];
    }
    
    //Refresh data in the tableview
    [tableView2 reloadData];
    
    if (isConnectedSel)
    {
        didFinishLoadingSel = YES;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView -

/*******************
 *TableView methods*
 *******************/

//returns number or rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData2 count];
}

//Sets what each cell is going to look like in the tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    CustomTableCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (cell == nil) {
        cell = [[CustomTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    cell.tag = indexPath.row;
    
    //Load Json data for images
    NSArray *imageURL = [secondaryAppDel.jsonData objectForKey:[NSString stringWithFormat:@"%@_Images",secondaryAppDel.rootTableSelection]];
    
    //Load image and set it to the cells imageview.Load image with sdimageview
    [cell.imageView setImageWithURL:[NSURL URLWithString:imageURL[indexPath.row]]
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    //Set detail text. Shows the number of images in each gallery
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d images" ,[[secondaryAppDel.jsonData objectForKey:tableData2[indexPath.row]] count]];
    
    //Set main text for the cell
    cell.textLabel.text = [tableData2 objectAtIndex:indexPath.row];
    
    //Set background image for the cell
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellBackgroundSel.png"]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellBackgroundSelClick.png"]];
    cell.backgroundColor = RGBA(224, 224,224, 1);
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
    //Set global variable. Stored the selection made in the tableview to be used in the next view
    secondaryAppDel.secondTableSelection = tableData2[indexPath.row];
    
    //Deselect cell after its clicked
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //Initiates the next View
    ThumbNailViewController *thumbNails =[[ThumbNailViewController alloc] init];
    
    //Pushed the new view
    if (thumbNails)
    {
        [self.navigationController pushViewController:thumbNails animated:YES];
    }
}
//Sets height for the tableview cells
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.0f;
}

#pragma mark - Internet -

/***************************
 *Tests internet connection*
 ***************************/

- (void)testInternetConnection
{
    __weak typeof(self) weakSelf = self;
    
    internetReachableSel = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Internet is reachable
    internetReachableSel.reachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            //Removes the warning
            if (!weakSelf.internetAlertSelBackground.hidden)
            {
                [weakSelf.internetAlertSelBackground slideOutTo:kFTAnimationTop duration:.3 delegate:nil];
            }
            
            //Tells the app that there is now an internet conencton
            isConnectedSel = YES;
            
            //Loads the view if it wants laoded already
            if (!didFinishLoadingSel)
            {
                [weakSelf.tableView2 reloadData];
            }
        });
    };
    
    // Internet is not reachable
    internetReachableSel.unreachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            //Pushes the warning view
            if (![weakSelf.internetAlertSelBackground isDescendantOfView:weakSelf.view])
            {
                [weakSelf.view insertSubview:weakSelf.internetAlertSelBackground aboveSubview:weakSelf.tableView2];
            }
            if (weakSelf.internetAlertSelBackground.hidden)
            {
                [weakSelf.internetAlertSelBackground slideInFrom:kFTAnimationTop duration:.3 delegate:nil];
            }
            isConnectedSel = NO;
        });
    };
    
    [internetReachableSel startNotifier];
}

@end
