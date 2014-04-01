//
//  EtsySearch.h
//  Etsy InfiniSearch
//
//  Created by Michael MacDougall on 3/26/14.
//  Copyright (c) 2014 Michael MacDougall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EtsyListing.h"
#import "NSString+HTML.h"
#import "EtsySortMethod.h"
#import "EtsyConstants.h"

@protocol EtsySearchDelegate <NSObject>

// Returns search results from Etsy when NSURL connection is complete
- (void)searchDidFinish:(NSMutableArray *)searchResults;

// If no results are found
- (void)noResultsFound;

// If search fails for any reason this method is invoked
- (void)searchFailed;

@end

@interface EtsySearch : NSObject

@property (nonatomic, weak) id <EtsySearchDelegate> delegate;

// Initializes object and starts async connection
- (id) initWithKeyword:(NSString *)keyword offset:(int)offset andSortMethod: (EtsySortMethod *)sortMethod;

@end
