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

@synthesize delegate;

- (void) searchWithURLString:(NSString *)urlString
{
    // Initialize Response Data
    responseData = [[NSMutableData alloc]init];
    
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
    
    // Alert delegate that search is finished and pass results
    if([[responseDataDictionary objectForKey:@"count"] intValue] > 0)
    {
        [delegate searchDidFinish:responseDataDictionary];
    }
    else
    {
        [delegate noResultsFound];
    }
}

@end
