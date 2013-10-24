//
//  XNavigationService.m
//  BirdKit
//
//  Created by Cameron Saul on 3/22/13.
//  Copyright (c) 2013 Expa. All rights reserved.
//

#import "XNavigationService.h"
#import "XLogging.h"

static UINavigationController *_navigationController;
const NSString *XNavigationServiceDelegateParam = @"Delegate";

@implementation XNavigationService

+ (void)setNavigationController:(UINavigationController *)navigationController {
	_navigationController = navigationController;
}

+ (void)navigateTo:(NSString *)destination params:(NSDictionary *)params {
	NSAssert(_navigationController, @"you must call setNavigationController: before using the navigation service!");
	
	Class class = NSClassFromString(destination);
	UIViewController *vc;
	if ([class instancesRespondToSelector:@selector(initWithParams:)]) {
		if ([class respondsToSelector:@selector(validateParams:)]) {
			[class validateParams:params];
		}
		vc = [[class alloc] initWithParams:params];
		XLog(self, LogFlagInfo, @"Pushed view controller %@ with params: %@", destination, params);
	} else {
		if (params) {
			XLog(self, LogFlagWarn, @"Warning! Passing params to class %@, which does not accept params.", destination);
		}
		vc = [[class alloc] init];
		XLog(self, LogFlagInfo, @"Pushed view controller %@", destination);
	}
	
	if (params[XNavigationServiceDelegateParam]) {
		if ([vc respondsToSelector:@selector(setDelegate:)]) {
			[(id)vc setDelegate:params[XNavigationServiceDelegateParam]];
		} else {
			XLog(self, LogFlagWarn, @"Warning! Passing XNavigationServiceDelegateParam to class %@, which does not respond to setDelegate:.", destination);
		}
	}
	
	[_navigationController pushViewController:vc animated:YES];
}

+ (void)popViewControllerAnimated:(BOOL)animated {
	[_navigationController popViewControllerAnimated:animated];
}

@end