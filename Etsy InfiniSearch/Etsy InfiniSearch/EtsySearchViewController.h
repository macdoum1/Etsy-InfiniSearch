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
#import "NSString+HTML.h"
#import "LoadMoreView.h"
#import "UIImageView+WebCache.h"
#import "EtsySortMethod.h"
#import "EtsySearch.h"



@interface EtsySearchViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UISearchBarDelegate,UIScrollViewDelegate,UIActionSheetDelegate,EtsySearchDelegate>

// UICollectionView to display search results
@property (nonatomic, strong) IBOutlet UICollectionView *searchResultsCollectionView;

// UISearchBar for entering keywords
@property (nonatomic, strong) IBOutlet UISearchBar *etsySearchBar;

// Custom UIView and UIActivityIndicatorView for loading more results
@property (nonatomic, strong) IBOutlet LoadMoreView *loadMoreView;

// UIView for sortbar
@property (nonatomic, strong) IBOutlet UIToolbar *sortBar;

// UIButton for sorting
@property (nonatomic, strong) IBOutlet UIButton *sortButton;

- (IBAction)sortBy:(id)sender;

@end
