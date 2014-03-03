//
//  XSingleton.m
//  ExpaPlatform
//
//  Created by Cam Saul on 3/2/14.
//  Copyright (c) 2014 Expa, LLC. All rights reserved.
//

#import <objc/runtime.h>

#import "XSingleton.h"
#import "XRuntimeUtilities.h"

@implementation XSingleton

ASSOC_CLASS_PROP_STRONG(XSingleton *, singletonInstance, setSingletonInstance)

+ (instancetype)alloc {
	@synchronized([self class]) {
		NSAssert(![self singletonInstance], @"Attempt to allocate a second instance of singleton class %@!", NSStringFromClass([self class]));
		return [super alloc];
	}
}

+ (instancetype)sharedInstance {
	@synchronized([self class]) {
		if (![self singletonInstance]) {
			[self setSingletonInstance:[[[self class] alloc] init]];
		}
		return [self singletonInstance];
	}
}


@end
