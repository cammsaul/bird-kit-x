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

inline void dispatch_async_high_priority(dispatch_block_t block) {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), block);
}

inline void dispatch_async_default_priority(dispatch_block_t block) {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

inline void dispatch_async_low_priority(dispatch_block_t block) {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), block);
}

inline void dispatch_async_background_priority(dispatch_block_t block) {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block);
}

inline void dispatch_async_main(dispatch_block_t block) {
	dispatch_async(dispatch_get_main_queue(), block);
}

inline void dispatch_sync_main(dispatch_block_t block) {
	dispatch_sync(dispatch_get_main_queue(), block);
}

inline void guarantee_on_main_thread(void(^block)()) {
	if		(NSThread.isMainThread) block();
	else	dispatch_sync_main(block);
}

// c++ version is a template in the header
#ifndef __cplusplus
	void with_weak_ref(id obj, weak_ref_block_t weak_ref_block) {
		__block __weak id weakRef = obj;
		weak_ref_block(weakRef);
	}
#endif