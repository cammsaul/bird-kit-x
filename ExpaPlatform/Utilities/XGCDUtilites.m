//
//  XGCDUtilites.m
//  ExpaPlatform
//
//  Created by Cameron Saul on 10/24/13.
//  Copyright (c) 2013 Expa, LLC. All rights reserved.
//

#import "XGCDUtilites.h"

inline void dispatch_after_seconds(const double delayInSeconds, dispatch_block_t block) {
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), block);
}

inline void dispatch_next_run_loop(dispatch_block_t block) {
	dispatch_after_seconds(0.001, block);
}

inline void dispatch_async_high_priority_queue(dispatch_block_t block) {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), block);
}

inline void dispatch_async_default_priority_queue(dispatch_block_t block) {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

inline void dispatch_async_low_priority_queue(dispatch_block_t block) {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), block);
}

inline void dispatch_async_background_priority_queue(dispatch_block_t block) {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block);
}

inline void dispatch_async_main_queue(dispatch_block_t block) {
	dispatch_async(dispatch_get_main_queue(), block);
}