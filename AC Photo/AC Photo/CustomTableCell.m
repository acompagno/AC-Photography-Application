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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake( 15,10, 70, 70 );
}

@end
