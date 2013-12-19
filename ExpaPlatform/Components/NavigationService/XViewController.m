//
//  XViewController.m
//  GeoTip
//
//  Created by Cameron Saul on 10/17/13.
//  Copyright (c) 2013 Series G. All rights reserved.
//

#import "XViewController.h"

/// Check and make sure various calls in the view lifcycle are properly forwarded to super by doing some checking here
@interface XViewController()
PROP BOOL viewDidLoadCalled;
PROP BOOL viewWillAppearCalled;
PROP BOOL viewDidAppearCalled;
PROP BOOL viewControllerWillBecomeActiveCalled;
PROP BOOL viewControllerDidBecomeActiveCalled;
PROP BOOL viewControllerWillBecomeInactiveCalled;
PROP BOOL viewControllerDidBecomeInactiveCalled;
PROP BOOL viewWillDisappearCalled;
PROP BOOL viewDidDisappearCalled;
@end

@implementation XViewController

+ (void)validateParams:(NSDictionary *)params {}; // default implementation does nothing

- (instancetype)init {
	if (self = [super init]) [self setup];
	return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) [self setup];
	return self;
}

- (instancetype)initWithParams:(NSDictionary *)params {
	if (self = [super init]) {
		_params = params;
		[self setup];
	}
	return self;
}

- (void)awakeFromNib {
	[self setup];
}

/// default implementation does nothing
- (void)setup {}

- (void)dealloc {
	// only check if we're being presented by a GeoTipNavigationController (soon-to-be XNavigationController)
	if (self.viewControllerWillBecomeInactiveCalled) {
		NSAssert(self.viewControllerDidBecomeInactiveCalled, @"[super viewControllerDidBecomeInactive:] never reached the XViewController. More than likely, you're missing that call in a subclass. Make sure all subclasses call super!");
	}
	NSAssert(self.viewDidDisappearCalled, @"[super viewDidDisappear:] never reached the XViewController. More than likely, you're missing that call in a subclass. Make sure all subclasses call super!");
	
	[NSNotificationCenter.defaultCenter removeObserver:self];
}
	
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.viewWillAppearCalled = YES;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.edgesForExtendedLayout = UIRectEdgeNone;
	self.viewDidLoadCalled = YES;
}

- (void)viewDidAppear:(BOOL)animated {
	NSAssert(self.viewDidLoadCalled, @"[super viewDidLoad:] never reached the XViewController. More than likely, you're missing that call in a subclass. Make sure all subclasses call super!");
	NSAssert(self.viewWillAppearCalled, @"[super viewWillAppear:] never reached the XViewController. More than likely, you're missing that call in a subclass. Make sure all subclasses call super!");
    [super viewDidAppear:animated];
	
	self.viewDidAppearCalled = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	NSAssert(self.viewDidAppearCalled, @"[super viewDidAppear:] never reached the XViewController. More than likely, you're missing that call in a subclass. Make sure all subclasses call super!");
	[super viewWillDisappear:animated];
	self.viewWillDisappearCalled = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
	NSAssert(self.viewWillDisappearCalled, @"[super viewWillDisappear:] never reached the XViewController. More than likely, you're missing that call in a subclass. Make sure all subclasses call super!");
	[super viewDidDisappear:animated];
	self.viewDidDisappearCalled = YES;
}

//----- These methods don't exist as part of expa-ios per se (GeoTipNavigationController calls them) YET -- they will soon -----//

- (void)viewControllerWillBecomeActive:(BOOL)animated {
	self.viewControllerWillBecomeActiveCalled = YES;
}

- (void)viewControllerDidBecomeActive:(BOOL)animated {
	NSAssert(self.viewControllerWillBecomeActiveCalled, @"[super viewControllerWillBecomeActive:] never reached the XViewController. More than likely, you're missing that call in a subclass. Make sure all subclasses call super!");
	
	// Since GTTracker isn't part of ExpaPlatform (yet) use ObjC runtime hackery to find the IMP and call it TODO.
	const Class trackingClass = NSClassFromString(@"GTTracker");
	#pragma clang diagnostic push
	#pragma clang diagnostic ignored "-Wundeclared-selector"
		const SEL trackingSel = @selector(setViewNameForViewController:);
	#pragma clang diagnostic pop
	const IMP _trackingImp = [trackingClass methodForSelector:trackingSel];
	void(*trackingImp)(id, SEL, UIViewController *) = (void(*)(id, SEL, UIViewController *))_trackingImp; // cast IMP to a c function so ARC doesn't try to release it
	trackingImp(trackingClass, trackingSel, self);
	
	self.viewControllerDidBecomeActiveCalled = YES;
}

- (void)viewControllerWillBecomeInactive:(BOOL)animated {
	NSAssert(self.viewControllerDidBecomeActiveCalled, @"[super viewControllerDidBecomeActive:] never reached the XViewController. More than likely, you're missing that call in a subclass. Make sure all subclasses call super!");
	self.viewControllerWillBecomeInactiveCalled = YES;
}

- (void)viewControllerDidBecomeInactive:(BOOL)animated {
	NSAssert(self.viewControllerWillBecomeInactiveCalled, @"[super viewControllerWillBecomeInactive:] never reached the XViewController. More than likely, you're missing that call in a subclass. Make sure all subclasses call super!");
	self.viewControllerDidBecomeInactiveCalled = YES;
}

//----- END GeoTip-only methods -----//


@end
