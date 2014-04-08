//
//  EtsySearchTests.m
//  Etsy InfiniSearch
//
//  Created by Michael MacDougall on 4/8/14.
//  Copyright (c) 2014 Michael MacDougall. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EtsySearch.h"
#import "EtsyListing.h"

@interface EtsySearchTests : XCTestCase

@end

@implementation EtsySearchTests

- (void)setUp
{
    [super setUp];

}

- (void)tearDown
{

    [super tearDown];
}


- (void)testEtsyListingCreate
{
    EtsyListing *listing = [[EtsyListing alloc]initWithTitle:@"TEST" andListingImageURL:@"asdasd.com"];
    XCTAssertNotNil(listing, @"Could not create EtsyListing Object");
    
    EtsyListing *listingTwo = [[EtsyListing alloc]initWithTitle:@"TEST" andListingImageURL:nil];
    XCTAssertNotNil(listingTwo, @"Could not create EtsyListing Object");
}

@end
