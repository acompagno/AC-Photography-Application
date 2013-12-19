//
//  CustomTableCell.m
//  AC Photo
//
//  Created by noname on 8/5/13.
//  Copyright (c) 2013 test. All rights reserved.
//

#import "CustomTableCell.h"

@implementation CustomTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(15 , 10 , 70 , 70);
    self.textLabel.frame = CGRectMake(95, self.textLabel.frame.origin.y, self.textLabel.frame.size.width , self.textLabel.frame.size.height);
    self.textLabel.highlightedTextColor = [UIColor whiteColor];
    
    self.detailTextLabel.frame = CGRectMake(95 , self.detailTextLabel.frame.origin.y , self.detailTextLabel.frame.size.width, self.detailTextLabel.frame.size.height) ;
    self.detailTextLabel.highlightedTextColor = [UIColor whiteColor];
}

@end
