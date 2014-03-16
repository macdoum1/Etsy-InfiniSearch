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

@synthesize searchResultsCollectionView,etsySearchBar;

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
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // Dismiss keyboard once search is pressed
    [searchBar resignFirstResponder];
    
    // Create NSString using API URL, API Key, and the contents of the search bar
    NSString *urlString = [NSString stringWithFormat:@"https://api.etsy.com/v2/listings/active?api_key=%@&includes=MainImage&keywords=%@",API_KEY,searchBar.text];
    
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
    NSString *responseDataString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"Response: %@",responseDataString);
}

// Determines how many cells should be shown
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    //
    return 200;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1; //PLACEHOLDER
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"ResultCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor greenColor];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath

{
    // Returns the size of a particular cell
    return CGSizeMake(50, 100); //PLACEHOLDER
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    // Returns the inset of the UICollection
    return UIEdgeInsetsMake(10, 5, 0, 5);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
