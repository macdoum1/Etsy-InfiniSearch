//
//  EtsySortMethod.m
//  Etsy InfiniSearch
//
//  Created by Michael MacDougall on 4/8/14.
//  Copyright (c) 2014 Michael MacDougall. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EtsySortMethod.h"

@interface EtsySortMethodTests : XCTestCase

@end

@implementation EtsySortMethodTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreateEtsySortMethod
{
    EtsySortMethod *sort = [[EtsySortMethod alloc]initWithName:@"TestSort" andPrefix:@"/test/"];
    XCTAssertNotNil(sort, @"Could not create EtsySort Object");
    
    EtsySortMethod *sortTwo = [[EtsySortMethod alloc]initWithName:nil andPrefix:nil];
    XCTAssertNotNil(sortTwo, @"Could not create EtsySort Object");
}

@end
