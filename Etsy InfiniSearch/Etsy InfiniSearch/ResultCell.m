//
//  ResultCell.m
//  Etsy InfiniSearch
//
//  Created by Michael MacDougall on 3/16/14.
//  Copyright (c) 2014 Michael MacDougall. All rights reserved.
//

#import "ResultCell.h"

@implementation ResultCell

@synthesize listingImage,listingLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:15];
        [self.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
        self.layer.shouldRasterize = YES;
        self.layer.opaque = YES;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}


@end
