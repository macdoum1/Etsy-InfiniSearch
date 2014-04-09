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
#import "EtsySearchViewController.h"
#import "AppDelegate.h"

@interface EtsySearchTests : XCTestCase

@property (nonatomic, strong) AppDelegate *delegate;

@end

@implementation EtsySearchTests

- (void)setUp
{
    [super setUp];
    
    
    self.delegate = [[UIApplication sharedApplication]delegate];

}

- (void)tearDown
{

    [super tearDown];
}


- (void)testEtsyListingCreate
{
    EtsyListing *listing = [[EtsyListing alloc]initWithTitle:@"TEST" andListingImageURL:@"asdasd.com"];
    XCTAssertNotNil(listing, @"Could not create EtsyListing Object");
    
    EtsyListing *listingTwo = [[EtsyListing alloc]initWithTitle:nil andListingImageURL:nil];
    XCTAssertNotNil(listingTwo, @"Could not create EtsyListing Object");
}

- (void)testCreateEtsySortMethod
{
    EtsySortMethod *sort = [[EtsySortMethod alloc]initWithName:@"TestSort" andPrefix:@"/test/"];
    XCTAssertNotNil(sort, @"Could not create EtsySort Object");
    
    EtsySortMethod *sortTwo = [[EtsySortMethod alloc]initWithName:nil andPrefix:nil];
    XCTAssertNotNil(sortTwo, @"Could not create EtsySort Object");
}

- (void)testSearch
{
    EtsySearchViewController *searchVC = (EtsySearchViewController *) self.delegate.window.rootViewController;
    
    id<UISearchBarDelegate> searchDelegate = [searchVC.etsySearchBar delegate];
    
    searchVC.etsySearchBar.text = @"animals";
    [searchDelegate searchBarSearchButtonClicked:searchVC.etsySearchBar];
    
    [[NSRunLoop currentRunLoop] runUntilDate:
     [NSDate dateWithTimeIntervalSinceNow: 3]];
    
    XCTAssertNotEqual([searchVC.searchResultsCollectionView numberOfItemsInSection:0], 0, @"No results loaded into CollectionView for search term \"animals\"");
    
    searchVC.etsySearchBar.text = @"hats";
    [searchDelegate searchBarSearchButtonClicked:searchVC.etsySearchBar];
    
    [[NSRunLoop currentRunLoop] runUntilDate:
     [NSDate dateWithTimeIntervalSinceNow: 3]];
    
    XCTAssertNotEqual([searchVC.searchResultsCollectionView numberOfItemsInSection:0], 0, @"No results loaded into CollectionView for search term \"hats\"");
    
    searchVC.etsySearchBar.text = @"|^#*$";
    [searchDelegate searchBarSearchButtonClicked:searchVC.etsySearchBar];
    
    [[NSRunLoop currentRunLoop] runUntilDate:
     [NSDate dateWithTimeIntervalSinceNow: 3]];
    
    XCTAssertEqual([searchVC.searchResultsCollectionView numberOfItemsInSection:0], 0, @"No results should be found for search \"|^#*$\"");
}

- (void)testSort
{
    EtsySearchViewController *searchVC = (EtsySearchViewController *) self.delegate.window.rootViewController;
    
    id<UISearchBarDelegate> searchDelegate = [searchVC.etsySearchBar delegate];

    searchVC.etsySearchBar.text = @"animals";
    [searchDelegate searchBarSearchButtonClicked:searchVC.etsySearchBar];
    
    [[NSRunLoop currentRunLoop] runUntilDate:
     [NSDate dateWithTimeIntervalSinceNow: 3]];
    
    XCTAssertNotEqual([searchVC.searchResultsCollectionView numberOfItemsInSection:0], 0, @"No results loaded into CollectionView for search term \"animals\"");
    
    [searchVC sortBy:self];
    
    id<UIActionSheetDelegate> actionSheetDelegate = searchVC;
    [actionSheetDelegate actionSheet:nil clickedButtonAtIndex:1];
    [[NSRunLoop currentRunLoop] runUntilDate:
     [NSDate dateWithTimeIntervalSinceNow:3]];
    XCTAssertNotEqual([searchVC.searchResultsCollectionView numberOfItemsInSection:0], 0, @"No results loaded into CollectionView for search term \"animals\" with Sorting (Highest Price)");
    [actionSheetDelegate actionSheet:nil clickedButtonAtIndex:4];
    
    [actionSheetDelegate actionSheet:nil clickedButtonAtIndex:2];
    [[NSRunLoop currentRunLoop] runUntilDate:
     [NSDate dateWithTimeIntervalSinceNow:3]];
    XCTAssertNotEqual([searchVC.searchResultsCollectionView numberOfItemsInSection:0], 0, @"No results loaded into CollectionView for search term \"animals\" with Sorting (Lowest Price)");
    [actionSheetDelegate actionSheet:nil clickedButtonAtIndex:4];
    
    [actionSheetDelegate actionSheet:nil clickedButtonAtIndex:3];
    [[NSRunLoop currentRunLoop] runUntilDate:
     [NSDate dateWithTimeIntervalSinceNow:3]];
    XCTAssertNotEqual([searchVC.searchResultsCollectionView numberOfItemsInSection:0], 0, @"No results loaded into CollectionView for search term \"animals\" with Sorting (Highest Score)");
    [actionSheetDelegate actionSheet:nil clickedButtonAtIndex:4];
    
    [actionSheetDelegate actionSheet:nil clickedButtonAtIndex:0];
    [[NSRunLoop currentRunLoop] runUntilDate:
     [NSDate dateWithTimeIntervalSinceNow:3]];
    XCTAssertNotEqual([searchVC.searchResultsCollectionView numberOfItemsInSection:0], 0, @"No results loaded into CollectionView for search term \"animals\" with Sorting (Most Recent)");
    [actionSheetDelegate actionSheet:nil clickedButtonAtIndex:4];
    
    
}

@end
