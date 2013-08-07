//
//  SelectionViewController.m
//  AC Photo
//
//  Created by noname on 8/4/13.
//  Copyright (c) 2013 test. All rights reserved.
//

#import "SelectionViewController.h"
#import "ThumbNailViewController.h"
#import "UIImageView+WebCache.h"
#import "CustomTableCell.h"
#define jsonDataURL [NSURL URLWithString:@"http://www.weebly.com/uploads/6/5/5/1/6551078/acphoto.json"]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


@interface SelectionViewController ()
@end

@implementation SelectionViewController

NSArray *TableData2;
NSDictionary* json_data;
NSMutableDictionary *TableViewImages;

- (void)viewDidLoad
{
    SecondaryAppDel=[[UIApplication sharedApplication]delegate];
    
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(224, 224,224, 1);
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    [self setTitle:SecondaryAppDel.RootTableSelection];
    // Do any additional setup after loading the view from its nib.
    NSData* data = [NSData dataWithContentsOfURL:
                    jsonDataURL];
    NSError* error;
    json_data = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    TableData2 = [json_data objectForKey:SecondaryAppDel.RootTableSelection];
    
    self.TableView2 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height)];
    
    self.TableView2.dataSource = self;
    self.TableView2.delegate = self;
    self.TableView2.backgroundColor = [UIColor clearColor];
    [self.TableView2 setSeparatorColor:[UIColor clearColor]];
    
    [self.TableView2 reloadData];
    
    [self.view addSubview:self.TableView2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [TableData2 count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    CustomTableCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (cell == nil) {
        cell = [[CustomTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    cell.tag = indexPath.row;
    
    NSArray *imageURL = [json_data objectForKey:[NSString stringWithFormat:@"%@_Images",SecondaryAppDel.RootTableSelection]];

    [cell.imageView setImageWithURL:[NSURL URLWithString:imageURL[indexPath.row]]
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    //[[json_data objectForKey:TableData2[indexPath.row]] count]
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d images" ,[[json_data objectForKey:TableData2[indexPath.row]] count]];
    cell.textLabel.text = [TableData2 objectAtIndex:indexPath.row];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellBackgroundSel.png"]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellBackgroundSelClick.png"]];

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SecondaryAppDel.SecondTableSelection = TableData2[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ThumbNailViewController *thumbNails =[[ThumbNailViewController alloc] init];
    
    [self.navigationController pushViewController:thumbNails animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.0f;
}

@end
