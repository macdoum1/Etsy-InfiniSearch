//
//  LoadMoreView.h
//  Etsy InfiniSearch
//
//  Created by Michael MacDougall on 3/16/14.
//  Copyright (c) 2014 Michael MacDougall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadMoreView : UIView

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *spinner;

- (void)slideUp;
- (void)slideDown;
@end
