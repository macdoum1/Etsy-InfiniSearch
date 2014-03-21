//
//  EtsySearchViewController.m
//  Etsy InfiniSearch
//
//  Created by Michael MacDougall on 3/15/14.
//  Copyright (c) 2014 Michael MacDougall. All rights reserved.
//

#import "EtsySearchViewController.h"

@interface EtsySearchViewController ()

// Holds NSURLConnection data
@property (nonatomic, strong) NSMutableData *responseData;

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


@synthesize searchResultsCollectionView,etsySearchBar,loadMoreView,sortButton,sortBar,responseData,searchResultsArray,currentKeyword,currentOffset,maximumScrollIndex,currentlyLoadingMore,searchIcon,spinner,sortMethods,currentSortMethod;

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
    
    // Initialize responseData
    responseData = [[NSMutableData alloc]init];
    
    // Set current offset to zero
    currentOffset = 0;
    
    // Set up sort methods
    sortMethods = [[NSArray alloc]initWithObjects:@"Most Recent",@"Highest Price",@"Lowest Price",@"Highest Score", nil];
    
    // Initialize indicator
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
}

//***Lock Orientation***
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
//**********************

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
            [spinner setFrame:CGRectMake(searchResultsCollectionView.frame.size.width/2, sortBar.frame.origin.y + 15, 0, 0)];
        }
        // If sortBar is not hidden place spinner below sortBar
        else
        {
            [spinner setFrame:CGRectMake(searchResultsCollectionView.frame.size.width/2, sortBar.frame.origin.y + 50, 0, 0)];
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
    
    // Select the correct URL postfix for the selected sorting method
    NSString *sortPostfix = @"";
    switch (currentSortMethod)
    {
        case 0:
            sortPostfix = @"";
            break;
        case 1:
            sortPostfix = @"&sort_on=price&sort_order=down";
            break;
        case 2:
            sortPostfix = @"&sort_on=price&sort_order=up";
            break;
        case 3:
            sortPostfix = @"&sort_on=score&sort_order=down";
            break;
        default:
            sortPostfix = @"";
            break;
    }

    // Create NSString using API URL, API Key, and the contents of the search bar
    NSString *urlString = [NSString stringWithFormat:@"https://api.etsy.com/v2/listings/active?api_key=%@&includes=MainImage&keywords=%@&offset=%d%@&limit=%d",API_KEY,keyword,offset,sortPostfix,NUM_RESULTS_PER_LOAD];
    
    // Create NSURL object from the URL String
    NSURL *requestURL = [[NSURL alloc]initWithString:urlString];
    
    // Create NSURLRequest object from URL
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:requestURL];
    
    // Create NSURLConnection from request object
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    if(!connection)
    {
        // UIAlert for failed connection
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                          message:@"Connection to the server could not be made"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
}

// NSURLConnection didReceiveResponse Delegate Method
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [responseData setLength:0];
}

// NSURLConnection didReceiveData Delegate Method
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

// NSURLConnection didFailWithError Delegate Method
- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // UIAlert for failed connection
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                      message:@"Connection to the server could not be made"
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
}

// NSURLConnection didFinishLoading Delegate Method
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error;
    // Parse response data to dictionary object using JSONSerialization
    NSDictionary *responseDataDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    // Ensure more than zero results
    if([[responseDataDictionary objectForKey:@"count"] intValue] > 0)
    {
        // Get results and store in NSArray
        NSArray* allResults = [responseDataDictionary objectForKey:@"results"];
        
        // Parse results into EtsyListing objects
        [self parseSearchResults:allResults];
    }
    else
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
}

// Parses search results into EtsyListing objects
- (void)parseSearchResults:(NSArray *)results
{
    for(NSDictionary *currentResult in results)
    {        
        // Initialize object
        EtsyListing *currentListing = [[EtsyListing alloc]init];
        
        // Get title from dictionary
        currentListing.listingTitle = [[currentResult objectForKey:@"title"] kv_decodeHTMLCharacterEntities];
        
        // Get image URL from dictionary
        NSDictionary *mainImageDict = [currentResult objectForKey:@"MainImage"];
        currentListing.listingImageURL = [mainImageDict objectForKey:@"url_170x135"];
        
        // Add to array
        [searchResultsArray addObject:currentListing];
    }
    
   
    
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

// Determines how many cells should be shown
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    // Ensures that number of listings to be shown is divisible by the column count
    // to prevent asymmetry. However if 
    return [searchResultsArray count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    // Only one section is needed
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Dequeue with ID into custom cell
    ResultCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"ResultCell" forIndexPath:indexPath];
    
    // Get correct listing from searchResultsArray
    EtsyListing *tempListing = [searchResultsArray objectAtIndex:indexPath.row];
    
    // Set Image with URL using SDWebImage (supports cacheing and loading asynchronously)
    [cell.listingImage setImageWithURL:[NSURL URLWithString:tempListing.listingImageURL]];

    // Set cell listing title from Etsy listing object
    cell.listingLabel.text = tempListing.listingTitle;

    
    // Ensure image does not exceed edges of mask (due to cell needing maskToBounds off for drop shadow)
    cell.listingImage.layer.masksToBounds = YES;

    // Set drop shadow of UICollectionViewCell
    cell.layer.masksToBounds = NO;
    cell.layer.borderColor = [[UIColor whiteColor] CGColor];
    cell.layer.borderWidth = 1.0f;
    cell.layer.contentsScale = [UIScreen mainScreen].scale;
    cell.layer.shadowRadius = 4.0f;
    cell.layer.shadowOpacity = 0.75f;
    cell.layer.shadowOffset = CGSizeZero;
    cell.layer.shadowPath = [UIBezierPath bezierPathWithRect:cell.bounds].CGPath;
    cell.layer.shouldRasterize = YES;
    
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
    
    if(maximumScrollIndex == currentOffset)
    {
        // Clear cache to prevent memory leaks
        [[SDImageCache sharedImageCache] clearMemory];
    }
    
    // If the highest visible indexPath is the same as the last index of the searchResults array
    // load more results & filters out extraneous loads
    if(maximumScrollIndex == (([searchResultsArray count] - ([searchResultsArray count] % NUM_OF_COLS) - 1)) && !currentlyLoadingMore)
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
    // Show UIActionSheet when SortBy method button is pressed
    [self showSortByActionSheet];
}

-(void)showSortByActionSheet
{
    // Initialize actionSheet
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Sort By:" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    // Add sort methods to action sheet from array
    for(NSString *s in sortMethods)
    {
        [actionSheet addButtonWithTitle:s];
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
        [sortButton setTitle:[sortMethods objectAtIndex:buttonIndex] forState:UIControlStateNormal];
        
        // Perform new search
        [self performNewSearch];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
