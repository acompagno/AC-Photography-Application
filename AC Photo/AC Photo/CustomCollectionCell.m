//
//  CustomCollectionCell.m
//  AC Photo
//
//  Created by noname on 8/4/13.
//  Copyright (c) 2013 test. All rights reserved.
//

#import "CustomCollectionCell.h"

@implementation CustomCollectionCell
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupImageView];
    }
    return self;
}

#pragma mark - Create Subviews

- (void)setupImageView {
    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.imageView.autoresizingMask = UIViewAutoresizingNone;//UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.imageView];
}

@end