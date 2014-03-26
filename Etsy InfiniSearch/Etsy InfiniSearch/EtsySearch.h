//
//  EtsySearch.h
//  Etsy InfiniSearch
//
//  Created by Michael MacDougall on 3/26/14.
//  Copyright (c) 2014 Michael MacDougall. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EtsySearchDelegate <NSObject>
- (void)searchDidFinish:(NSDictionary *)searchResults;
- (void)searchFailed;

@end

@interface EtsySearch : NSObject

@property (nonatomic, weak) id <EtsySearchDelegate> delegate;

- (void) searchWithURLString:(NSString *)urlString;

@end
