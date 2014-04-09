//
//  EtsySearchViewController.m
//  Etsy InfiniSearch
//
//  Created by Michael MacDougall on 3/15/14.
//  Copyright (c) 2014 Michael MacDougall. All rights reserved.
//

#import "EtsySearchViewController.h"

@interface EtsySearchViewController ()

// Holds search results
@property (nonatomic, strong) NSMutableArray *searchResultsArray;

// Current keyword for loading more pages
@property (nonatomic, strong) NSString *currentKeyword;

// Current maximum scroll index
@property (nonatomic) NSInteger maximumScrollIndex;
@property (nonatomic) BOOL currentlyLoadingMore;

// Views need for adding search/loading indicator
@property (nonatomic, strong) UIView *searchIcon;
@property (nonatomic, strong) MMLoadingIndicator *spinner;

// NSArray of sorting methods
@property (nonatomic, strong) NSArray *sortMethods;

// Current sort method
@property (nonatomic) NSInteger currentSortMethod;

// Etsy Search Object
@property (nonatomic, strong) EtsySearch *etsySearch;

// Custom UIView and UIActivityIndicatorView for loading more results
@property (nonatomic, strong) LoadMoreView *loadMoreView;

@end

@implementation EtsySearchViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Set UICollectionView Delegate
    _searchResultsCollectionView.delegate = self;
    
    // Set UICollectionView Source
    _searchResultsCollectionView.dataSource = self;
    
    // Set UISearchBar Delegate
    _etsySearchBar.delegate = self;
    
    // Set up sort methods
    _sortMethods = [[NSArray alloc]initWithObjects:
                   [[EtsySortMethod alloc]initWithName:@"Most Recent" andPrefix:@""],
                   [[EtsySortMethod alloc]initWithName:@"Highest Price" andPrefix:@"&sort_on=price&sort_order=down"],
                   [[EtsySortMethod alloc]initWithName:@"Lowest Price" andPrefix:@"&sort_on=price&sort_order=up"],
                   [[EtsySortMethod alloc]initWithName:@"Highest Score" andPrefix:@"&sort_on=score&sort_order=down"],nil];
    
    // Initialize indicator & add to superview
    _spinner = [[MMLoadingIndicator alloc]initWithFrame:CGRectMake((_sortBar.frame.size.width/2) - _spinner.frame.size.width/2, _searchResultsCollectionView.frame.origin.y + 50, _spinner.frame.size.width, _spinner.frame.size.height)];

    [self.view addSubview:_spinner];
    
    // Initialize LoadMoreView offscreen & add to superview
    self.loadMoreView = [[LoadMoreView alloc]initWithFrame:CGRectMake(0, 568, 320, 44)];
    [self.view addSubview:_loadMoreView];
    
    // Setup Autolayout constraints
    [self setupLayoutConstraints];
    
}

#pragma mark - Searching & Loading
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // Dismiss keyboard once search is pressed
    [searchBar resignFirstResponder];
    
    // Store current keyword for loading more results later
    _currentKeyword = searchBar.text;
    
    // Perform new search
    [self performNewSearch];
}

- (void)performNewSearch
{
    // Initialize searchResultsArray
    _searchResultsArray = [[NSMutableArray alloc]init];
    
    // Initialize EtsySearch object
    _etsySearch = [[EtsySearch alloc]init];
    
    // Ensure scrollIndex is 0 with each new search
    _maximumScrollIndex = 0;
    
    // Load search results
    [self loadSearchResultsWithOffset];
    
    // Switch search icon to loading indicator
    [_spinner startAnimating];
    
    // Reload UICollectionView
    [_searchResultsCollectionView reloadData];
    
    // Wipe cache from both disk and memory to avoid any buildup
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)loadSearchResultsWithOffset
{
    // UTF8 String encoding
    NSString *keyword = [_currentKeyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    EtsySortMethod *sortMethod = [_sortMethods objectAtIndex:_currentSortMethod];
    
    [_etsySearch searchWithKeyword:keyword andSortMethod:sortMethod];
    _etsySearch.delegate = self;
}

- (void) loadMoreResults
{
    // Enable currently loading more flag to prevent extra loads
    _currentlyLoadingMore = true;
    
    // Show LoadMoreView as loading indicator
    [_loadMoreView slideUp];
    
    // Load more results
    [self loadSearchResultsWithOffset];
    
}

#pragma mark - EtsySearchDelegate Methods
// EtsySearchDelegate searchDidFinish method
- (void)searchDidFinish:(NSMutableArray *)searchResults
{
    // Append objects from EtsySearch to array to be displayed
    [_searchResultsArray addObjectsFromArray:searchResults];
    
    // Reload UICollectionView Data
    [_searchResultsCollectionView reloadData];
    
    if(_etsySearch.currentOffset == 0)
    {
        // Reset UICollectionView scroll (in case of previous scrolling)
        [_searchResultsCollectionView scrollToItemAtIndexPath:0 atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
    // Switch loading indicator to search icon
    [_spinner stopAnimating];
    
    // Show sorting bar
    [_sortBar setHidden:NO];
    
    if(_currentlyLoadingMore)
    {
        // Reset LoadMoreView
        [_loadMoreView slideDown];
    }
    
    // Reset currentlyLoadingMore flag
    _currentlyLoadingMore = false;
    
    
}

// EtsySearchDelegate noResultsFound method
- (void)noResultsFound
{
    // Switch loading indicator to search icon
    [_spinner stopAnimating];
    
    // Disable sort bar if no results are found
    [_sortBar setHidden:YES];
}

// EtsySearchDelegate searchFailed method
- (void)searchFailedWithError:(NSError *)error
{
    if([error code] == -1009)
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Connection failed"
                                                          message:[error localizedDescription]
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
    
    // Switch loading indicator to search icon
    [_spinner stopAnimating];
    
    // Disable sort bar if no results are found
    [_sortBar setHidden:YES];
}

#pragma mark - UICollectionView Delegate Methods
// Determines how many cells should be shown
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    // Returns number of items in searchResultsArray
    return [_searchResultsArray count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    // Only one section is needed
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Determine if first element in each load
    if(indexPath.row == _etsySearch.currentOffset + 1)
    {
        // Clear cache to prevent memory leaks
        [[SDImageCache sharedImageCache] clearMemory];
    }
    // Dequeue with ID into custom cell
    ResultCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"ResultCell" forIndexPath:indexPath];
    
    // Get correct listing from searchResultsArray
    EtsyListing *tempListing = [_searchResultsArray objectAtIndex:indexPath.row];
    
    // Format and set both the label and image of the cell
    [cell setImage:tempListing.listingImageURL andTitle:tempListing.listingTitle];
    
    // Return cell
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    // Returns the inset of the UICollection
    return UIEdgeInsetsMake(5, 10, 0, 10);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Get all indexPaths from UICollectionView that are currently visible
    NSArray *visibleIndexPaths = [_searchResultsCollectionView indexPathsForVisibleItems];
    for(NSIndexPath *indexPath in visibleIndexPaths)
    {
        // Determine the highest indexPath that is visible
        if(indexPath.row > _maximumScrollIndex)
        {
            _maximumScrollIndex = indexPath.row;
        }
    }
    
    // If the highest visible indexPath is the same as the last index of the searchResults array
    // load more results & filters out extraneous loads
    if((_maximumScrollIndex == [_searchResultsArray count] - 1) && !_currentlyLoadingMore)
    {
        [self loadMoreResults];
    }
}

#pragma mark - Sorting

- (IBAction)sortBy:(id)sender
{
    // Initialize actionSheet
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Sort By:" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    // Add sort methods to action sheet from array
    for(EtsySortMethod *s in _sortMethods)
    {
        [actionSheet addButtonWithTitle:s.sortMethodName];
    }
    
    // Add cancel button to action sheet (to ensure its at the end of the actionsheet)
    [actionSheet addButtonWithTitle:@"Cancel"];
    [actionSheet setCancelButtonIndex:[_sortMethods count]];
    
    // Show actionsheet
    [actionSheet showInView:self.view];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Ensure buttonIndex is in range, not cancel, and not the same as the current sort method
    if(_currentKeyword != NULL && buttonIndex < [_sortMethods count] && !(_currentSortMethod == buttonIndex))
    {
        // Set current sort method
        _currentSortMethod = buttonIndex;
        
        // Set button text to match current sort method
        [_sortButton setTitle:((EtsySortMethod *)[_sortMethods objectAtIndex:buttonIndex]).sortMethodName forState:UIControlStateNormal];
        
        // Perform new search
        [self performNewSearch];
    }
}

#pragma mark - AutoLayoutConstraints
- (void)setupLayoutConstraints
{
    // Constraints for Spinner
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_spinner
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:100.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_spinner
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:100.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_spinner
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]];
    // Constraints for LoadMoreView
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_loadMoreView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_loadMoreView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:44.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_loadMoreView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:44.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_loadMoreView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_loadMoreView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0.0]];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
