//
//  XViewController.m
//  GeoTip
//
//  Created by Cameron Saul on 10/17/13.
//  Copyright (c) 2013 Series G. All rights reserved.
//

#import "XViewController.h"

@class GTTracker;

@implementation XViewController

+ (void)validateParams:(NSDictionary *)params {}; // default implementation does nothing

- (id)initWithParams:(NSDictionary *)params {
	if (self = [super init]) {
		_params = params;
	}
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
	// Since GTTracker isn't part of ExpaPlatform (yet) use Obj-C runtime hackery to find the IMP and call it TODO.
	const Class trackingClass = NSClassFromString(@"GTTracker");
	#pragma clang diagnostic ignored "-Wundeclared-selector"
	const SEL trackingSel = @selector(setViewName:);
	const IMP trackingImp = [trackingClass methodForSelector:trackingSel];
	trackingImp(trackingClass, trackingSel, NSStringFromClass([self class]));
}

@end
