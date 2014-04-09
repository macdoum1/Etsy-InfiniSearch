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
        
        // Set background of view to clear
        self.backgroundColor = [UIColor clearColor];
        
        // Set as hidden
        self.alpha = 0;
        
        // Allows for autolayout
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    // Get current context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Get Etsy orange color from RGB values
    UIColor *etsyOrange = [UIColor colorWithRed:212.0/255.0f green:100.0/255.0f blue:41.0/255.0f alpha:1];
    
    // Set stroke color & line width
    CGContextSetStrokeColorWithColor(context, etsyOrange.CGColor);
    CGContextSetLineWidth(context, INDICATOR_STROKE_WIDTH);
    
    // Add semi-circle
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2, INDICATOR_RADIUS, 0, M_PI, 0);
    
    // Draw semi-circle
    CGContextStrokePath(context);
}

#pragma testPragma

- (void) startAnimating
{
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate.duration = INDICATOR_DURATION;
    rotate.removedOnCompletion = NO;
    rotate.toValue = [NSNumber numberWithFloat:0.0f];
    rotate.repeatCount = HUGE_VALF;
    rotate.toValue = [NSNumber numberWithFloat:M_PI *2];
    [self.layer addAnimation:rotate forKey:@"rotation"];
    
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{self.alpha = 1;}
                     completion:nil];
}

- (void) stopAnimating
{
    // Stop animation
    [UIView animateWithDuration:0.05
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{self.alpha = 0;}
                     completion:nil];
    [self.layer removeAnimationForKey:@"rotation"];
}


@end
