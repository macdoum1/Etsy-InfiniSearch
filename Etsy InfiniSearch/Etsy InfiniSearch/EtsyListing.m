//
//  EtsyListing.m
//  Etsy InfiniSearch
//
//  Created by Michael MacDougall on 3/15/14.
//  Copyright (c) 2014 Michael MacDougall. All rights reserved.
//

#import "EtsyListing.h"

@implementation EtsyListing

@synthesize listingTitle,listingImageURL;

- (id)initWithTitle:(NSString *)title andListingImageURL:(NSString *)url
{
    self = [super init];
    if(self)
    {
        self.listingTitle = title;
        self.listingImageURL = url;
    }
    return self;
}

@end
