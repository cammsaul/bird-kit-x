//
//  XGCDUtilites.h
//  ExpaPlatform
//
//  Created by Cameron Saul on 10/24/13.
//  Copyright (c) 2013 Expa, LLC. All rights reserved.
//

typedef void(^weak_ref_block_t)(id weakRef);

/// Shorthand for calling dispatch_after() to dispatch on the main thread after some delay.
void dispatch_after_seconds(const double delayInSeconds, dispatch_block_t block);

/// Shorthand for calling dispatch_after() to dispatch on the main thread after a millisecond.
/// Theoretically, this should be just enough time to make the block get executed on the next run loop, which will give you enough
/// Time to do UI updates, etc. before it is called.
void dispatch_next_run_loop(dispatch_block_t block);

/// shorthand for dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), block)
void dispatch_async_high_priority(dispatch_block_t block);

/// shorthand for dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
void dispatch_async_default_priority(dispatch_block_t block);

/// shorthand for dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), block)
void dispatch_async_low_priority(dispatch_block_t block);

/// shorthand for dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block)
void dispatch_async_background_priority(dispatch_block_t block);

/// shorthand for dispatch_async(dispatch_get_main_queue(), block)
void dispatch_async_main(dispatch_block_t block);

/// Helper method to create a weak reference to an object. Happens syncronously.
void with_weak_ref(id obj, weak_ref_block_t weak_ref_block);