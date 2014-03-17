//
//  EtsySearchViewController.m
//  Etsy InfiniSearch
//
//  Created by Michael MacDougall on 3/15/14.
//  Copyright (c) 2014 Michael MacDougall. All rights reserved.
//

#import "EtsySearchViewController.h"

@interface EtsySearchViewController ()

@end

@implementation EtsySearchViewController

@synthesize searchResultsCollectionView,etsySearchBar,loadMoreView,sortButton,sortPicker,sortPickerView,sortBar;

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
    [searchResultsCollectionView setDelegate:self];
    
    // Set UICollectionView Source
    [searchResultsCollectionView setDataSource:self];
    
    // Set UISearchBar Delegate
    [etsySearchBar setDelegate:self];
    
    // Initialize responseData
    responseData = [[NSMutableData alloc]init];
    
    // Set current offset to zero
    currentOffset = 0;
    
    // Set up sorting UIPicker and sort Methods
    sortMethods = [[NSArray alloc]initWithObjects:@"Most Recent",@"Highest Price",@"Lowest Price",@"Score", nil];
    [sortPicker setDelegate:self];
    [sortPicker setDataSource:self];
    sortPicker.showsSelectionIndicator = TRUE;
    [sortPicker selectRow:0 inComponent:0 animated:YES];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [sortMethods count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [sortMethods objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(currentKeyword != NULL)
    {
        NSString *selected = [sortMethods objectAtIndex:row];
        currentSortMethod = row;
        [sortButton setTitle:selected forState:UIControlStateNormal];
        [self performNewSearch];
    }
}

- (IBAction)doneSorting:(id)sender
{
    [sortPickerView setHidden:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{

    // Dismiss keyboard once search is pressed
    [searchBar resignFirstResponder];
    
    // Store current keyword for loading more results later
    currentKeyword = searchBar.text;
    
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
    [self loadSearchResultsWithKeyword:currentKeyword andOffset:0];
    
    // Switch search icon to loading indicator
    [self toggleSearchIndicator:0];
    
    [searchResultsCollectionView reloadData];
}

- (void)toggleSearchIndicator:(BOOL)flag
{
    // Get UITextField from UISearchBars subviews
    UITextField *searchField = nil;
    for (UIView *subview in [[etsySearchBar.subviews objectAtIndex:0] subviews])
    {
        if ([subview isKindOfClass:[UITextField class]])
        {
            searchField = (UITextField *)subview;
            break;
        }
    }
    if(searchField)
    {
        if(flag == 0)
        {
            // Initialize indicator
            spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
            // Store search icon for swapping back later
            searchIcon = searchField.leftView;
            
            // Replace search icon with indicator
            searchField.leftView = spinner;
            
            // Start animating indicator
            [spinner startAnimating];
        }
        else
        {
            // Swap indicator for search icon
            searchField.leftView = searchIcon;
            
            // Stop animating indicator
            [spinner stopAnimating];
        }
    }
}

- (void)loadSearchResultsWithKeyword:(NSString *)keyword andOffset:(int)offset
{
    // UTF8 String encoding
    keyword = [keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
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
    NSString *urlString = [NSString stringWithFormat:@"https://api.etsy.com/v2/listings/active?api_key=%@&includes=MainImage&keywords=%@&offset=%d%@",API_KEY,keyword,offset,sortPostfix];
    
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
        [self toggleSearchIndicator:1];
        
        // Disable sort bar if no results are found
        [sortBar setHidden:YES];
        
        // UIAlert for no results
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"No Results Found"
                                                          message:@""
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
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
    [self toggleSearchIndicator:1];
    
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
    // Return size of array/number of search results
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
    
    // Set attributes of cell using the listing object
    cell.listingImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:tempListing.listingImageURL]]];
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

/*- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath

{
    // Returns the size of a particular cell
    return CGSizeMake(50, 135); //PLACEHOLDER
}*/

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
    if(maximumScrollIndex == ([searchResultsArray count] - 1) && !currentlyLoadingMore)
    {
        [self loadMoreResults];
    }
}

- (void) loadMoreResults
{
    currentlyLoadingMore = true;
    
    [loadMoreView slideUp];
    
    // Update offset
    currentOffset = currentOffset + NUM_RESULTS_PER_LOAD;
    
    // Load More results
    [self loadSearchResultsWithKeyword:currentKeyword andOffset:currentOffset];
    
}

- (IBAction)sortBy:(id)sender
{
    [sortPickerView setHidden:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
