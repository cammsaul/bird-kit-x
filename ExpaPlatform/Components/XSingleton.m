//
//  XSingleton.m
//  ExpaPlatform
//
//  Created by Cam Saul on 3/2/14.
//  Copyright (c) 2014 Expa, LLC. All rights reserved.
//

#import "XSingleton.h"

@implementation XSingleton

+ (instancetype)alloc {
	@synchronized(self) {
		static id __sharedInstance = nil;
		NSAssert(!__sharedInstance, @"Attempt to allocate a second instance of singleton class %@!", NSStringFromClass([self class]));
		__sharedInstance = [super alloc];
		return __sharedInstance;
	}
}

+ (instancetype)sharedInstance {
	@synchronized(self) {
		static id __sharedInstance;
		if (!__sharedInstance) {
			__sharedInstance = [[[self class] alloc] init];
		}
		return __sharedInstance;
	}
}


@end
