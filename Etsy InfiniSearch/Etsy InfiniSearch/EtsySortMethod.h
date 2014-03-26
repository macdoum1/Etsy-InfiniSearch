//
//  EtsySortMethod.h
//  Etsy InfiniSearch
//
//  Created by Michael MacDougall on 3/26/14.
//  Copyright (c) 2014 Michael MacDougall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EtsySortMethod : NSObject

@property (nonatomic, strong) NSString *sortMethodName;
@property (nonatomic, strong) NSString *sortPrefix;

- (id) initWithName:(NSString *)name andPrefix:(NSString *)prefix;

@end
