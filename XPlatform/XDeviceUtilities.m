//
//  XDeviceUtilities.m
//  XPlatform
//
//  Created by Cameron Saul on 10/24/13.
//  Copyright (c) 2013 Cam Saül. All rights reserved.
//

#import "XDeviceUtilities.h"

BOOL is_ipad() {
	static int isIpad = -1;
	if (isIpad == -1) {
		isIpad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? 1 : 0;
	}
	return (BOOL)isIpad;
}

BOOL is_iphone() {
	return !is_ipad();
}

BOOL is_iphone_5() {
	return is_iphone() && [UIScreen mainScreen].bounds.size.height > 500.0f;
}

BOOL is_landscape() {
	return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].delegate.window.rootViewController.interfaceOrientation);
	//	if (is_iphone()) return YES; // iphone is always in landscape for this version of the app.
	//
	//	// device orientation seems to be the most accurate and up-to-date, but since face up / face down are considered valid orientations we can't always rely on device orientation.
	//	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	//	if (UIDeviceOrientationIsLandscape(orientation)) {
	//		return YES;
	//	} else if (UIDeviceOrientationIsPortrait(orientation)) {
	//		return NO;
	//	}
	//
	//	// inspect the toInterfaceOrientation of the modal view controller if it exists and it implements the ToInterfaceOrientation property
	//	UIViewController *presentedViewController = App_Delegate().rootViewController.presentedViewController;
	//	if (presentedViewController && [presentedViewController conformsToProtocol:@protocol(ToInterfaceOrientation)]) {
	//		UIViewController<ToInterfaceOrientation> *presentedVC = (UIViewController<ToInterfaceOrientation> *)presentedViewController;
	//		if ([presentedVC toInterfaceOrientation] != NSNotFound) {
	//			return UIInterfaceOrientationIsLandscape([presentedVC toInterfaceOrientation]);
	//		}
	//	}
	//
	//	return UIDeviceOrientationIsLandscape([(UIViewController<ToInterfaceOrientation> *)(App_Delegate().rootViewController) toInterfaceOrientation]);
}

BOOL is_portrait() {
	return !is_landscape();
}

BOOL is_ipad_landscape() {
	return is_ipad() && is_landscape();
}

BOOL is_ipad_portrait() {
	return is_ipad() && is_portrait();
}

BOOL is_retina() {
	return [UIScreen mainScreen].scale > 1;
}

BOOL is_ios7() {
	static BOOL _is_ios7 = -1;
	if ((int)_is_ios7 == -1) _is_ios7 = [[UIDevice currentDevice] systemVersion].floatValue >= 7.0f;
	return _is_ios7;
}

inline CGSize current_screen_size() {
	return [UIApplication sharedApplication].delegate.window.rootViewController.view.bounds.size;
}