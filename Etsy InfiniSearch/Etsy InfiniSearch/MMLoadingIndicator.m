//
//  MMLoadingIndicator.m
//  CustomLoading
//
//  Created by Michael MacDougall on 3/31/14.
//  Copyright (c) 2014 Michael MacDougall. All rights reserved.
//

#import "MMLoadingIndicator.h"

@implementation MMLoadingIndicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *etsyOrange = [UIColor colorWithRed:212.0/255.0f green:100.0/255.0f blue:41.0/255.0f alpha:1];
    CGContextSetStrokeColorWithColor(context, etsyOrange.CGColor);
    CGContextSetLineWidth(context, INDICATOR_STROKE_WIDTH);
    
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2, INDICATOR_RADIUS, 0, M_PI, 0);
    CGContextStrokePath(context);
    
}

- (void) startAnimating
{
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate.duration = INDICATOR_DURATION;
    rotate.removedOnCompletion = NO;
    rotate.toValue = [NSNumber numberWithFloat:0.0f];
    rotate.repeatCount = HUGE_VALF;
    rotate.toValue = [NSNumber numberWithFloat:M_PI *2];
    [self.layer addAnimation:rotate forKey:@"rotation"];
}

- (void) stopAnimating
{
    [self.layer removeAnimationForKey:@"rotation"];
}


@end
