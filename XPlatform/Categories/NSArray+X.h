//
//  NSArray+X.h
//  XPlatform
//
//  Created by Cameron T Saul on 8/14/15.
//  Copyright (c) 2015 Cam Saül. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (X)

/// Return a new array containing all items except for the one at the specified index.
- (NSArray *)arrayByRemovingItemAtIndex:(NSUInteger)index;

@end
