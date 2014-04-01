//
//  EtsySearch.m
//  Etsy InfiniSearch
//
//  Created by Michael MacDougall on 3/26/14.
//  Copyright (c) 2014 Michael MacDougall. All rights reserved.
//

#import "EtsySearch.h"

@implementation EtsySearch
{
    NSMutableData *responseData;
}

@synthesize delegate,currentOffset;

- (id) init
{
    self = [super init];
    if(self)
    {
        currentOffset = 0;
    }
    return self;
}

- (void) searchWithKeyword:(NSString *)keyword offset:(int)offset andSortMethod: (EtsySortMethod *)sortMethod
{
    // Initialize Response Data
    responseData = [[NSMutableData alloc]init];
    
    // Create NSString using API URL, API Key, and the contents of the search bar
    NSString *urlString = [NSString stringWithFormat:@"https://api.etsy.com/v2/listings/active?api_key=%@&includes=MainImage&keywords=%@&offset=%d%@&limit=%d",API_KEY,keyword,self.currentOffset,sortMethod.sortPrefix,NUM_RESULTS_PER_LOAD];
    
    // Create NSURL object from the URL String
    NSURL *requestURL = [[NSURL alloc]initWithString:urlString];
    
    // Create NSURLRequest object from URL
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:requestURL];
    
    // Create NSURLConnection from request object
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(!connection)
    {
        [delegate searchFailed];
    }
    currentOffset = currentOffset + NUM_RESULTS_PER_LOAD;
}

// NSURLConnection didReceiveResponse Method
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [responseData setLength:0];
}

// NSURLConnection didReceiveData Method
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

// NSURLConnection didFailWithError Method
- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // Alert delegate that search failed
    [delegate searchFailed];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error;
    
    // Parse response data to dictionary object using JSONSerialization
    NSDictionary *responseDataDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    if(error == NULL)
    {
        // Alert delegate that search is finished and pass results
        if([[responseDataDictionary objectForKey:@"count"] intValue] > 0)
        {
            // Initialize array for list of Etsy Listing Objects
            NSMutableArray *parsedEtsyListings = [[NSMutableArray alloc]init];
            
            // Get results from dictionary
            NSArray* allResults = [responseDataDictionary objectForKey:@"results"];
            
            // Parse results into EtsyListing objects
            for(NSDictionary *currentResult in allResults)
            {
                // Initialize object with title and imageURL from dictionary
                EtsyListing *currentListing = [[EtsyListing alloc]
                                               initWithTitle:[[currentResult objectForKey:@"title"] kv_decodeHTMLCharacterEntities]
                                               andListingImageURL:[[currentResult objectForKey:@"MainImage"] objectForKey:@"url_170x135"]];
                // Add to array
                [parsedEtsyListings addObject:currentListing];
            }

            [delegate searchDidFinish:parsedEtsyListings];
        }
        else
        {
            [delegate noResultsFound];
        }
    }
    else
    {
        [delegate searchFailed];
    }
}

@end
