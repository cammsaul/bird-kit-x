//  -*-ObjC-*-
//  NSMutableArray+Queue.h
//  Cam Saül
//
//  Created by Cameron Saul on 6/15/13.
//  Copyright (c) 2013 Cam Saül. All rights reserved.
//

/// Provides dequeue and enqueue methods to use a NSMutableArray like a queue.
@interface NSMutableArray (X)

/// Returns (and removes) the first (oldest) object in the queue.
/// Returns nil if no objects are currently in the queue.
- (id)dequeue;

/// Adds a new object to the end of the queue.
/// @param obj the object to add at the end of the queue.
- (void)enqueue:(id)obj;

@end
