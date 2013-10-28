//
//  XViewController.m
//  GeoTip
//
//  Created by Cameron Saul on 10/17/13.
//  Copyright (c) 2013 Series G. All rights reserved.
//

#import "XViewController.h"

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
	
	// Since GTTracker isn't part of ExpaPlatform (yet) use ObjC runtime hackery to find the IMP and call it TODO.
	const Class trackingClass = NSClassFromString(@"GTTracker");
	#pragma clang diagnostic ignored "-Wundeclared-selector"
	const SEL trackingSel = @selector(setViewNameForViewController:);
	const IMP _trackingImp = [trackingClass methodForSelector:trackingSel];
	void(*trackingImp)(id, SEL, UIViewController *) = (void(*)(id, SEL, UIViewController *))_trackingImp; // cast IMP to a c function so ARC doesn't try to release it
	trackingImp(trackingClass, trackingSel, self);
}

@end
