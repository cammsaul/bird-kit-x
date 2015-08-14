//
//  NSMutableArray+Queue.m
//  Cam Saül
//
//  Created by Cameron Saul on 6/15/13.
//  Copyright (c) 2013 Cam Saül. All rights reserved.
//

#import "NSMutableArray+X.h"

@implementation NSMutableArray (X)

- (id)dequeue {
    if ([self count] == 0) return nil;
    id head = [self objectAtIndex:0];
	[self removeObjectAtIndex:0];
	return head;
}

- (void)enqueue:(id)anObject {
    [self addObject:anObject]; // adds at the end of the array
}
@end