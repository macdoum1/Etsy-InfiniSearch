//
//  EtsySearchViewController.h
//  Etsy InfiniSearch
//
//  Created by Michael MacDougall on 3/15/14.
//  Copyright (c) 2014 Michael MacDougall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EtsyConstants.h"

@interface EtsySearchViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UISearchBarDelegate>
{
    NSMutableData *responseData;
}

// UICollectionView to display search results
@property (nonatomic, strong) IBOutlet UICollectionView *searchResultsCollectionView;

// UISearchBar for entering keywords
@property (nonatomic, strong) IBOutlet UISearchBar *etsySearchBar;

@end
