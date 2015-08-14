//
//  NSArray+X.m
//  XPlatform
//
//  Created by Cameron T Saul on 8/14/15.
//  Copyright (c) 2015 Cam Saül. All rights reserved.
//

#import "NSArray+X.h"

@implementation NSArray (X)

- (NSArray *)arrayByRemovingItemAtIndex:(NSUInteger)index {
    NSMutableArray *m = [self mutableCopy];
    [m removeObjectAtIndex:index];
    return m;
}

@end
