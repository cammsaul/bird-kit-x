//
//  XViewController.m
//  GeoTip
//
//  Created by Cameron Saul on 10/17/13.
//  Copyright (c) 2013 Series G. All rights reserved.
//

#import <objc/runtime.h>

#import "XViewController.h"
#import "NSDictionary+Expa.h"
#import "XRuntimeUtilities.h"
@implementation XViewController

+ (void)validateParams:(NSDictionary *)params {}; // default implementation does nothing

/// We don't want to accidentally call setup multiple times is various subclasses do/don't implement different versions of init, etc
ASSOC_PROP_STRONG(NSNumber *, hasCalledSetup, setHasCalledSetup);

- (instancetype)init {
	if (self = [super init]) [self callSetup];
	return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) [self callSetup];
	return self;
}

- (instancetype)initWithParams:(NSDictionary *)params {
	if (self = [super init]) {
		_params = params;
        if (params[XNavigationServiceDelegateParam]) {
            if ([self respondsToSelector:@selector(setDelegate:)]) {
                [(id)self setDelegate:params[XNavigationServiceDelegateParam]];
                _params = [_params dictionaryBySettingValue:nil forKey:XNavigationServiceDelegateParam];
            }
        }
		[self callSetup];
	}
	return self;
}

- (void)awakeFromNib {
	[self callSetup];
}

/// Helper to check self.hasCalledSetup so we don't do it more than once
- (void)callSetup {
	if (self.hasCalledSetup) return; // already done
	self.hasCalledSetup = @YES;
	[self setup];
}

/// default implementation does nothing
- (void)setup {}

- (void)dealloc {
	[NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.edgesForExtendedLayout = UIRectEdgeNone;
}

//----- These methods don't exist as part of expa-ios per se (GeoTipNavigationController calls them) YET -- they will soon -----//

- (void)viewControllerDidBecomeActive:(BOOL)animated {
	// Since GTTracker isn't part of ExpaPlatform (yet) use ObjC runtime hackery to find the IMP and call it TODO.
	const Class trackingClass = NSClassFromString(@"GTTracker");
	#pragma clang diagnostic push
	#pragma clang diagnostic ignored "-Wundeclared-selector"
		const SEL trackingSel = @selector(setViewNameForViewController:);
	#pragma clang diagnostic pop
	const IMP _trackingImp = [trackingClass methodForSelector:trackingSel];
	void(*trackingImp)(id, SEL, UIViewController *) = (void(*)(id, SEL, UIViewController *))_trackingImp; // cast IMP to a c function so ARC doesn't try to release it
	trackingImp(trackingClass, trackingSel, self);
}

// default implementations of these do nothing
- (void)viewControllerWillBecomeActive:(BOOL)animated {}
- (void)viewControllerWillBecomeInactive:(BOOL)animated {}
- (void)viewControllerDidBecomeInactive:(BOOL)animated {}

//----- END GeoTip-only methods -----//


@end
