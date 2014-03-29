//
//  EtsySortMethod.m
//  Etsy InfiniSearch
//
//  Created by Michael MacDougall on 3/26/14.
//  Copyright (c) 2014 Michael MacDougall. All rights reserved.
//

#import "EtsySortMethod.h"

@implementation EtsySortMethod

@synthesize sortMethodName;
@synthesize sortPrefix;

- (id) initWithName:(NSString *)name andPrefix:(NSString *)prefix
{
    self = [super init];
    if(self)
    {
        self.sortMethodName = name;
        self.sortPrefix = prefix;
    }
    return self;
}
@end
