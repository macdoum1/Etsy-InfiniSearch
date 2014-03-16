//
//  EtsySearchViewController.h
//  Etsy InfiniSearch
//
//  Created by Michael MacDougall on 3/15/14.
//  Copyright (c) 2014 Michael MacDougall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EtsyConstants.h"
#import "EtsyListing.h"
#import "ResultCell.h"

@interface EtsySearchViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UISearchBarDelegate,UIScrollViewDelegate>
{
    // Holds NSURLConnection data
    NSMutableData *responseData;
    
    // Holds search results
    NSMutableArray *searchResultsArray;
    
    // Current keyword & current offset for loading more pages
    NSString *currentKeyword;
    int currentOffset;
}

// UICollectionView to display search results
@property (nonatomic, strong) IBOutlet UICollectionView *searchResultsCollectionView;

// UISearchBar for entering keywords
@property (nonatomic, strong) IBOutlet UISearchBar *etsySearchBar;

//- (void)loadSearchResultsWithKeyword:(NSString *)keyword andOffset:(int)offset;

@end
