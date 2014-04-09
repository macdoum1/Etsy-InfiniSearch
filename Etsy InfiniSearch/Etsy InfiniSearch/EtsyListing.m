//
//  EtsyListing.m
//  Etsy InfiniSearch
//
//  Created by Michael MacDougall on 3/15/14.
//  Copyright (c) 2014 Michael MacDougall. All rights reserved.
//

#import "EtsyListing.h"

@implementation EtsyListing

- (id)initWithTitle:(NSString *)title andListingImageURLString:(NSString *)url
{
    self = [super init];
    if(self)
    {
        self.listingTitle = title;
        self.listingImageURL = [NSURL URLWithString:url];
    }
    return self;
}

@end
