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

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define totalWidth ((CGFloat) self.view.bounds.size.width)
#define totalHeight ((CGFloat) self.view.bounds.size.height)
#define isiOS7 ((BOOL) [[Utils alloc] sysVersionGreaterThanOrEqualTo:@"7.0"])
#define navHeight ((int) [[Utils alloc] getNavBarHeight:self.navigationController.navigationBar.frame.size.height withStatusbar:[UIApplication sharedApplication].statusBarFrame.size.height])

@interface SelectionViewController ()
@end

@implementation SelectionViewController

BOOL didFinishLoadingSel = NO;
BOOL isConnectedSel = NO ;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /**************************
     *Internet connection test*
     **************************/
    [self testInternetConnection];
    
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
    
    /*************************
     *Set up internet warning*
     *************************/
    self.internetAlertSelBackground = [[UIView alloc] initWithFrame:CGRectMake(0 , -33 , totalWidth , 33)];
    self.internetAlertSelBackground.backgroundColor = RGBA(204 , 61 , 61 , .90);
    self.internetAlertSelBackground.hidden = YES;
    UILabel *yourLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 , 3 , totalWidth , 30)];
    [yourLabel setTextAlignment:NSTextAlignmentCenter];
    [yourLabel setTextColor:[UIColor whiteColor]];
    [yourLabel setBackgroundColor:[UIColor clearColor]];
    [yourLabel setText:@"No Internet Connection"];
    [yourLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [self.internetAlertSelBackground addSubview:yourLabel];
    
    /******************
     *Set up TableView*
     ******************/
    self.tableView2 = isiOS7 ? [[UITableView alloc] initWithFrame:CGRectMake(0, 0, totalWidth, totalHeight)] : [[UITableView alloc] initWithFrame:CGRectMake(0, 0, totalWidth, totalHeight - navHeight)];
    
    if (self.tableView2)
    {
        self.tableView2.dataSource = self;
        self.tableView2.delegate = self;
        self.tableView2.backgroundColor = RGBA(224, 224,224, 1);
        [self.tableView2 setSeparatorColor:[UIColor clearColor]];
        [self.tableView2 reloadData];
        
        //Add Views
        [self.view addSubview:self.tableView2];
    }
    
    if (self.tableView2 && self.internetAlertSelBackground)
    {
        [self.view insertSubview:self.internetAlertSelBackground aboveSubview:self.tableView2];
    }
    
    //Refresh data in the tableview
    [self.tableView2 reloadData];
    
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
    CustomTableCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (cell == nil)
    {
        cell = [[CustomTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.tag = indexPath.row;
    
    //Load Json data for images
    NSArray *imageURL = [secondaryAppDel.jsonData objectForKey:[NSString stringWithFormat:@"%@_Images",secondaryAppDel.rootTableSelection]];
    
    //Load image and set it to the cells imageview.Load image with sdimageview
    [cell.imageView setImageWithURL:[NSURL URLWithString:imageURL[indexPath.row]]
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    //Set detail text. Shows the number of images in each gallery
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d images" ,[[secondaryAppDel.jsonData objectForKey:tableData2[indexPath.row]] count]];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    //Set main text for the cell
    cell.textLabel.text = [tableData2 objectAtIndex:indexPath.row];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0f;
}

#pragma mark - Internet -

/***************************
 *Tests internet connection*
 ***************************/

- (void)testInternetConnection
{
    __weak typeof(self) weakSelf = self;
    int navHeightTemp = navHeight;
    internetReachableSel = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Internet is reachable
    internetReachableSel.reachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            //Removes the warning
            if (!weakSelf.internetAlertSelBackground.hidden)
            {
                [[Utils alloc] animationSlideOut:weakSelf.internetAlertSelBackground];
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
            if (weakSelf.internetAlertSelBackground.hidden)
            {
                [[Utils alloc] animationSlideIn:weakSelf.internetAlertSelBackground shouldUseiOS7Offset:isiOS7 navBarHeight:navHeightTemp];
            }
            isConnectedSel = NO;
        });
    };
    
    [internetReachableSel startNotifier];
}

@end
