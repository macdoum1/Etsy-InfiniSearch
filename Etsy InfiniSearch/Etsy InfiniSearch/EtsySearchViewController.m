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

// Current keyword & current offset for loading more pages
@property (nonatomic, strong) NSString *currentKeyword;
@property (nonatomic) int currentOffset;

// Current maximum scroll index
@property (nonatomic) NSInteger maximumScrollIndex;
@property (nonatomic) BOOL currentlyLoadingMore;

// Views need for adding search/loading indicator
@property (nonatomic, strong) UIView *searchIcon;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

// NSArray of sorting methods
@property (nonatomic, strong) NSArray *sortMethods;

// Current sort method
@property (nonatomic) NSInteger currentSortMethod;

@end

@implementation EtsySearchViewController


@synthesize searchResultsCollectionView,etsySearchBar,loadMoreView,sortButton,sortBar,searchResultsArray,currentKeyword,currentOffset,maximumScrollIndex,currentlyLoadingMore,searchIcon,spinner,sortMethods,currentSortMethod;

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
    searchResultsCollectionView.delegate = self;
    
    // Set UICollectionView Source
    searchResultsCollectionView.dataSource = self;
    
    // Set UISearchBar Delegate
    etsySearchBar.delegate = self;
    
    // Set current offset to zero
    currentOffset = 0;
    
    // Set up sort methods
    sortMethods = [[NSArray alloc]initWithObjects:
                   [[EtsySortMethod alloc]initWithName:@"Most Recent" andPrefix:@""],
                   [[EtsySortMethod alloc]initWithName:@"Highest Price" andPrefix:@"&sort_on=price&sort_order=down"],
                   [[EtsySortMethod alloc]initWithName:@"Lowest Price" andPrefix:@"&sort_on=price&sort_order=up"],
                   [[EtsySortMethod alloc]initWithName:@"Highest Score" andPrefix:@"&sort_on=score&sort_order=down"],nil];
    
    // Initialize indicator
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // Dismiss keyboard once search is pressed
    [searchBar resignFirstResponder];
    
    // Store current keyword for loading more results later
    currentKeyword = searchBar.text;
    
    // Perform new search
    [self performNewSearch];
}

- (void)performNewSearch
{
    // Initialize searchResultsArray
    searchResultsArray = [[NSMutableArray alloc]init];
    
    // Ensure the offset is 0 with each new search
    currentOffset = 0;
    
    // Ensure scrollIndex is 0 with each new search
    maximumScrollIndex = 0;
    
    // Load search results
    [self loadSearchResultsWithOffset:0];
    
    // Switch search icon to loading indicator
    [self toggleSearchIndicator:1];
    
    // Reload UICollectionView
    [searchResultsCollectionView reloadData];
}

- (void)toggleSearchIndicator:(int)flag
{
    if(flag)
    {
        // If sortBar is hidden, place spinner below searchBar
        if([sortBar isHidden])
        {
            [spinner setFrame:CGRectMake(sortBar.frame.size.width/2, sortBar.frame.origin.y + 15, 0, 0)];
        }
        // If sortBar is not hidden place spinner below sortBar
        else
        {
            [spinner setFrame:CGRectMake(sortBar.frame.size.width/2, sortBar.frame.origin.y + 50, 0, 0)];
        }
        
        // Add spinner to view & start animating
        [self.view addSubview:spinner];
        [spinner startAnimating];
    }
    else
    {
        // Remove spinner from view & stop animating
        [spinner removeFromSuperview];
        [spinner stopAnimating];
    }
}

- (void)loadSearchResultsWithOffset:(int)offset
{
    // UTF8 String encoding
    NSString *keyword = [currentKeyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    EtsySortMethod *sortMethod = [sortMethods objectAtIndex:currentSortMethod];

    // Create NSString using API URL, API Key, and the contents of the search bar
    NSString *urlString = [NSString stringWithFormat:@"https://api.etsy.com/v2/listings/active?api_key=%@&includes=MainImage&keywords=%@&offset=%d%@&limit=%d",API_KEY,keyword,offset,sortMethod.sortPrefix,NUM_RESULTS_PER_LOAD];
    
    EtsySearch *search = [[EtsySearch alloc]initWithURLString:urlString];
    search.delegate = self;
}

// EtsySearchDelegate searchDidFinish method
- (void)searchDidFinish:(NSMutableArray *)searchResults
{
    // Append objects from EtsySearch to array to be displayed
    [searchResultsArray addObjectsFromArray:searchResults];
    
    // Reload UICollectionView Data
    [searchResultsCollectionView reloadData];
    
    if(currentOffset == 0)
    {
        // Reset UICollectionView scroll (in case of previous scrolling)
        [searchResultsCollectionView scrollToItemAtIndexPath:0 atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
    // Switch loading indicator to search icon
    [self toggleSearchIndicator:0];
    
    // Show sorting bar
    [sortBar setHidden:NO];
    
    // Reset currentlyLoadingMore flag
    currentlyLoadingMore = false;
    
    // Reset LoadMoreView
    [loadMoreView slideDown];
}

// EtsySearchDelegate noResultsFound method
- (void)noResultsFound
{
    // Switch loading indicator to search icon
    [self toggleSearchIndicator:0];
    
    // Disable sort bar if no results are found
    [sortBar setHidden:YES];
    
    // Do not show no results found if no more listings exist
    if(!currentlyLoadingMore)
    {
        // UIAlert for no results
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"No Results Found"
                                                          message:@""
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
}

// EtsySearchDelegate searchFailed method
- (void)searchFailed
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Connection failed"
                                                      message:@"Please check your internet connection"
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
}

// Determines how many cells should be shown
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    // Returns number of items in searchResultsArray
    return [searchResultsArray count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    // Only one section is needed
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Determine if first element in each load
    if(indexPath.row == currentOffset + 1)
    {
        // Clear cache to prevent memory leaks
        [[SDImageCache sharedImageCache] clearMemory];
    }
    // Dequeue with ID into custom cell
    ResultCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"ResultCell" forIndexPath:indexPath];
    
    // Get correct listing from searchResultsArray
    EtsyListing *tempListing = [searchResultsArray objectAtIndex:indexPath.row];
    
    // Format and set both the label and image of the cell
    [cell formatAndSetImage:tempListing.listingImageURL andTitle:tempListing.listingTitle];
    
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
    NSArray *visibleIndexPaths = [searchResultsCollectionView indexPathsForVisibleItems];
    for(NSIndexPath *indexPath in visibleIndexPaths)
    {
        // Determine the highest indexPath that is visible
        if(indexPath.row > maximumScrollIndex)
        {
            maximumScrollIndex = indexPath.row;
        }
    }
    
    // If the highest visible indexPath is the same as the last index of the searchResults array
    // load more results & filters out extraneous loads
    if((maximumScrollIndex == [searchResultsArray count] - 1) && !currentlyLoadingMore)
    {
        [self loadMoreResults];
    }
}

- (void) loadMoreResults
{
    currentlyLoadingMore = true;
    
    // Show LoadMoreView as loading indicator
    [loadMoreView slideUp];
    
    // Update offset
    currentOffset = currentOffset + NUM_RESULTS_PER_LOAD;
    
    // Load more results
    [self loadSearchResultsWithOffset:currentOffset];
    
}

- (IBAction)sortBy:(id)sender
{
    // Initialize actionSheet
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Sort By:" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    // Add sort methods to action sheet from array
    for(EtsySortMethod *s in sortMethods)
    {
        [actionSheet addButtonWithTitle:s.sortMethodName];
    }
    
    // Add cancel button to action sheet (to ensure its at the end of the actionsheet)
    [actionSheet addButtonWithTitle:@"Cancel"];
    [actionSheet setCancelButtonIndex:[sortMethods count]];
    
    // Show actionsheet
    [actionSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Ensure buttonIndex is in range, not cancel, and not the same as the current sort method
    if(currentKeyword != NULL && buttonIndex < [sortMethods count] && !(currentSortMethod == buttonIndex))
    {
        // Set current sort method
        currentSortMethod = buttonIndex;
        
        // Set button text to match current sort method
        [sortButton setTitle:((EtsySortMethod *)[sortMethods objectAtIndex:buttonIndex]).sortMethodName forState:UIControlStateNormal];
        
        // Perform new search
        [self performNewSearch];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
