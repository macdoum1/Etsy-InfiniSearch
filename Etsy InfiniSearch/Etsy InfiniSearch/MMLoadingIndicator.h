//
//  MMLoadingIndicator.h
//  CustomLoading
//
//  Created by Michael MacDougall on 3/31/14.
//  Copyright (c) 2014 Michael MacDougall. All rights reserved.
//

#import <UIKit/UIKit.h>

// Constants for size/duration
#define INDICATOR_STROKE_WIDTH  10
#define INDICATOR_RADIUS        20
#define INDICATOR_DURATION      1

@interface MMLoadingIndicator : UIView

- (void) startAnimating;
- (void) stopAnimating;

@end
