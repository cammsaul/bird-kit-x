//
//  NSMutableArray+Queue.m
//  Expa
//
//  Created by Cameron Saul on 6/15/13.
//  Copyright (c) 2013 Expa. All rights reserved.
//

#import "NSMutableArray+Expa.h"

@implementation NSMutableArray (Expa)

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