//
//  XGCDUtilites.h
//  ExpaPlatform
//
//  Created by Cameron Saul on 10/24/13.
//  Copyright (c) 2013 Expa, LLC. All rights reserved.
//

/// Shorthand for calling dispatch_after() to dispatch on the main thread after some delay.
void dispatch_after_seconds(const double delayInSeconds, dispatch_block_t block);

/// Shorthand for calling dispatch_after() to dispatch on the main thread after a millisecond.
/// Theoretically, this should be just enough time to make the block get executed on the next run loop, which will give you enough
/// Time to do UI updates, etc. before it is called.
void dispatch_next_run_loop(dispatch_block_t block);
