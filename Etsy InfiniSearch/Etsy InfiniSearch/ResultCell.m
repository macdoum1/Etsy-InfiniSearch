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
    if (self)
    {
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}

- (void)formatCell
{
    // Set drop shadow, border and other cell formatting options
    self.layer.masksToBounds = NO;
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.layer.borderWidth = 1.0f;
    self.layer.contentsScale = [UIScreen mainScreen].scale;
    self.layer.shadowRadius = 4.0f;
    self.layer.shadowOpacity = 0.75f;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    self.layer.shouldRasterize = YES;
    self.listingImage.layer.masksToBounds = YES;
}

- (void)formatAndSetImage:(NSString *)imageURL andTitle:(NSString *)title
{
    // Set Image with URL using SDWebImage (supports cacheing and loading asynchronously)
    [self.listingImage setImageWithURL:[NSURL URLWithString:imageURL]];
    
    // Set UILabel
    self.listingLabel.text = title;
    
    // Format cell
    [self formatCell];
}


@end
