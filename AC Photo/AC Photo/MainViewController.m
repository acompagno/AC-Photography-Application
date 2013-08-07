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
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define jsonDataURL [NSURL URLWithString:@"http://www.weebly.com/uploads/6/5/5/1/6551078/acphoto.json"]

@interface MainViewController ()
@end

@implementation MainViewController
@synthesize scrollViewFeatured;
@synthesize TableViewMain;
@synthesize pageControl;
NSArray *MainTableData;
NSDictionary* json_data;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Featured"];
    self.view.backgroundColor = [UIColor darkGrayColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    [self.navigationController.navigationBar setTintColor:RGBA(9 , 213 , 115 , 1)];
    [self.navigationController.navigationBar setBackgroundImage:[[[Utils alloc] init] imageWithColor:RGBA(9 , 213 , 115 , 1)]
                                                  forBarMetrics:UIBarMetricsDefault];
    MainAppDel=[[UIApplication sharedApplication]delegate];
    NSData* data = [NSData dataWithContentsOfURL:
                    jsonDataURL];
    NSError* error;
    json_data = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    MainTableData = [json_data objectForKey:@"main_page"];
    self.pageControl = [[UIPageControl alloc] init];
    if (self.view.bounds.size.height > 460)
    {
        self.pageControl.frame = CGRectMake( 0, 400 , self.view.bounds.size.width, 17);
    }
    else
    {
        self.pageControl.frame = CGRectMake( 0, 315 , self.view.bounds.size.width, 15);
    }
    [self.pageControl setNumberOfPages:5];
    [self.pageControl setCurrentPage:0];
    [self.pageControl setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.pageControl];
    
    self.scrollViewFeatured = [[UIScrollView alloc] init];
    [self.scrollViewFeatured setPagingEnabled:YES];
    NSArray *featured;
    if (self.view.bounds.size.height > 460)
    {
        self.scrollViewFeatured.frame = CGRectMake(0,0, self.view.frame.size.width, 400);
        featured = [json_data objectForKey:@"Featured_4"];
    }
    else
    {
        self.scrollViewFeatured.frame = CGRectMake( 0, 0 ,  self.view.frame.size.width, 315);
        featured = [json_data objectForKey:@"Featured_3"];
    }
    self.scrollViewFeatured.backgroundColor =   [UIColor clearColor];
    self.scrollViewFeatured.contentSize = CGSizeMake(self.scrollViewFeatured.frame.size.width*5, self.scrollViewFeatured.frame.size.height);
    self.scrollViewFeatured.backgroundColor = [UIColor clearColor];
    self.scrollViewFeatured.delegate = self;
    self.scrollViewFeatured.showsHorizontalScrollIndicator=NO;
    CGFloat x=0;
    for(int i=1;i<6;i++)
    {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(x+0, 0, self.view.frame.size.width, self.scrollViewFeatured.frame.size.height)];
        [image setImageWithURL:[NSURL URLWithString:featured[i-1]]];
        [self.scrollViewFeatured addSubview:image];
        x+=320;
    }
    self.TableViewMain = [[UITableView alloc] init];
    if (self.view.bounds.size.height > 460)
    {
        self.TableViewMain .frame = CGRectMake(0  , self.scrollViewFeatured.frame.size.height + 17, self.view.bounds.size.width, 88);
    }
    else
    {
        self.TableViewMain .frame = CGRectMake(0  , 330, self.view.bounds.size.width,330);
    }
    self.TableViewMain.dataSource = self;
    self.TableViewMain.delegate = self;
    self.TableViewMain.backgroundColor = [UIColor clearColor];
    self.TableViewMain.scrollEnabled = NO;
    [self.TableViewMain setSeparatorColor:[UIColor darkGrayColor]];
    
    [self.TableViewMain reloadData];
    
    [self.view addSubview:self.scrollViewFeatured];
    [self.view addSubview:self.TableViewMain];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [MainTableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [MainTableData objectAtIndex:indexPath.row];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellBackgroundMain.png"]];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = self.scrollViewFeatured.contentOffset.x/self.scrollViewFeatured.frame.size.width;
    pageControl.currentPage=page;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainAppDel.RootTableSelection = MainTableData[indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SelectionViewController *selectionView=[[SelectionViewController alloc] init];
    
    [self.navigationController pushViewController:selectionView animated:YES];
}
-(NSUInteger)supportedInterfaceOrientations{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIDeviceOrientationLandscapeRight || orientation == UIDeviceOrientationLandscapeLeft)
    {
        return UIInterfaceOrientationMaskLandscape;
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
}
- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
