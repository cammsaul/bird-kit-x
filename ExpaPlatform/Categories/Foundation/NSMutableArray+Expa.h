//  -*-ObjC-*-
//  NSMutableArray+Queue.h
//  Expa
//
//  Created by Cameron Saul on 6/15/13.
//  Copyright (c) 2013 Expa. All rights reserved.
//

/// Provides dequeue and enqueue methods to use a NSMutableArray like a queue.
@interface NSMutableArray (Expa)

/// Returns (and removes) the first (oldest) object in the queue.
/// Returns nil if no objects are currently in the queue.
- (id)dequeue;

/// Adds a new object to the end of the queue.
- (void)enqueue:(id)obj;

@end
