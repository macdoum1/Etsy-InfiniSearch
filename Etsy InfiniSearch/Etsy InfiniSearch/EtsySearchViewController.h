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
#import "MMLoadingIndicator.h"

@interface EtsySearchViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UISearchBarDelegate,UIScrollViewDelegate,UIActionSheetDelegate,EtsySearchDelegate>

// UICollectionView to display search results
@property (nonatomic, weak) IBOutlet UICollectionView *searchResultsCollectionView;

// UISearchBar for entering keywords
@property (nonatomic, weak) IBOutlet UISearchBar *etsySearchBar;

// UIView for sortbar
@property (nonatomic, weak) IBOutlet UIToolbar *sortBar;

// UIButton for sorting
@property (nonatomic, weak) IBOutlet UIButton *sortButton;

- (IBAction)sortBy:(id)sender;

@end
