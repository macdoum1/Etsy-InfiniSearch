//
//  EtsyListing.h
//  Etsy InfiniSearch
//
//  Created by Michael MacDougall on 3/15/14.
//  Copyright (c) 2014 Michael MacDougall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EtsyListing : NSObject

@property (nonatomic, strong) NSString *listingTitle;
@property (nonatomic, strong) NSURL *listingImageURL;

- (id)initWithTitle:(NSString *)title andListingImageURLString:(NSString *)url;

@end
