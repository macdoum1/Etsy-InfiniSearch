//
//  LoadMoreView.m
//  Etsy InfiniSearch
//
//  Created by Michael MacDougall on 3/16/14.
//  Copyright (c) 2014 Michael MacDougall. All rights reserved.
//

#import "LoadMoreView.h"

@implementation LoadMoreView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Make background white
        self.backgroundColor = [UIColor whiteColor];
        
        // Initialize UIActivityIndicatorView
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        // Set frame for spinner
        [_spinner setFrame:CGRectMake(frame.size.width/2 - _spinner.frame.size.width/2, frame.size.height/2 - _spinner.frame.size.height/2, 20, 20)];
        
        // Set color of spinner to Etsy orange
        [_spinner setColor:[UIColor colorWithRed:212.0/255.0f green:100.0/255.0f blue:41.0/255.0f alpha:1]];
        
        // Add spinner to superview
        [self addSubview:_spinner];
        
        // Allows for autolayout
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_spinner setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        // Setup autolayout
        [self setupLayoutConstraints];
        
        // Start as hidden
        self.hidden = YES;
    }
    return self;
}

- (void)slideUp
{
    [_spinner startAnimating];
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.hidden = NO;
                         [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y - self.frame.size.height, self.frame.size.width, self.frame.size.height)];
                     }
                     completion:nil];
    
}

- (void)slideDown
{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height)];
                     }
                     completion:^(BOOL finished){
                         self.hidden = YES;
                     }];
    [_spinner stopAnimating];
}

- (void)setupLayoutConstraints
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_spinner
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]];
}

@end
