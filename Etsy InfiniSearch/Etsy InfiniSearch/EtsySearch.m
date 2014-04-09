//
//  EtsySearch.m
//  Etsy InfiniSearch
//
//  Created by Michael MacDougall on 3/26/14.
//  Copyright (c) 2014 Michael MacDougall. All rights reserved.
//

#import "EtsySearch.h"

@implementation EtsySearch

- (id) init
{
    self = [super init];
    if(self)
    {
        self.currentOffset = 0;
    }
    return self;
}

- (void) searchWithKeyword:(NSString *)keyword andSortMethod: (EtsySortMethod *)sortMethod
{
    // Create NSString using API URL, API Key, and the contents of the search bar
    NSString *urlString = [NSString stringWithFormat:@"https://api.etsy.com/v2/listings/active?apiself.key=%@&includes=MainImage&keywords=%@&offset=%d%@&limit=%d",API_KEY,keyword,self.currentOffset,sortMethod.sortPrefix,NUM_RESULTS_PER_LOAD];
    
    // Create NSURL object from the URL String
    NSURL *requestURL = [[NSURL alloc]initWithString:urlString];
    
    // Create NSURLRequest object from URL
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:requestURL];
    
    // Asynchronous NSURLConnection
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
        NSError *error;
        
        if(connectionError == NULL)
        {
            // Parse response data to dictionary object using JSONSerialization
            NSDictionary *responseDataDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
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
                                                       initWithTitle:[[currentResult objectForKey:@"title"] kvself.decodeHTMLCharacterEntities]
                                                       andListingImageURL:[[currentResult objectForKey:@"MainImage"] objectForKey:@"urlself.170x135"]];
                        // Add to array
                        [parsedEtsyListings addObject:currentListing];
                    }
                    
                    [self.delegate searchDidFinish:parsedEtsyListings];
                }
                else
                {
                    [self.delegate noResultsFound];
                }
            }
            else
            {
                [self.delegate searchFailedWithError:error];
            }
        }
        else
        {
            [self.delegate searchFailedWithError:connectionError];
        }
    }];
    self.currentOffset = self.currentOffset + NUMself.RESULTSself.PERself.LOAD;
}

@end
