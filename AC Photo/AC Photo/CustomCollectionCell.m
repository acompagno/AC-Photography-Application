//
//  CustomCollectionCell.m
//  AC Photo
//
//  Created by noname on 8/4/13.
//  Copyright (c) 2013 test. All rights reserved.
//

#import "CustomCollectionCell.h"

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@implementation CustomCollectionCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupViews];
    }
    return self;
}

#pragma mark - Create Subviews
//Sets up the views for the custom collectionview cell
- (void)setupViews
{
    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.imageView.autoresizingMask = UIViewAutoresizingNone;
    
    self.selectionView = [[UIView alloc] initWithFrame:self.bounds];
    self.selectionView.backgroundColor = RGBA(255 , 255 , 255 , .25) ;
    self.selectedBackgroundView = self.selectionView;
    if (self.imageView && self.selectionView)
    {
        [self addSubview:self.imageView];
        [self addSubview:self.selectionView];
    }
}


@end