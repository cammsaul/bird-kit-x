//
//  XNavigationService.m
//  Expa
//
//  Created by Cameron Saul on 3/22/13.
//  Copyright (c) 2013 Expa. All rights reserved.
//

#import "XNavigationService.h"
#import "NSDictionary+Expa.h"
#import "XLogging.h"

static UINavigationController *__navigationController;

@implementation XNavigationService

+ (void)setNavigationController:(UINavigationController *)navigationController {
	NSAssert(navigationController, @"You should not set navigation controller to nil!");
	XLog(self, LogFlagInfo, @"Root navigation controller set to: %@", navigationController);
	__navigationController = navigationController;
}

+ (UINavigationController *)navigationController {
	return __navigationController;
}

+ (void)navigateTo:(NSString *)destination params:(NSDictionary *)params {
	NSAssert(__navigationController, @"you must call setNavigationController: before using the navigation service!");
	
	id delegate = params[XNavigationServiceDelegateParam];
	
	Class class = NSClassFromString(destination);
	UIViewController *vc;
	if ([class instancesRespondToSelector:@selector(initWithParams:)]) {
		if ([class respondsToSelector:@selector(validateParams:)]) {
			[class validateParams:params];
		}
		if (delegate) params = [params dictionaryBySettingValue:nil forKey:XNavigationServiceDelegateParam]; // remove delegate from dictionary so it isn't retained
		vc = [[class alloc] initWithParams:params];
		XLog(self, LogFlagInfo, @"Pushed view controller %@ with params: %@", destination, params);
	} else {
		if (params) {
			XLog(self, LogFlagWarn, @"Warning! Passing params to class %@, which does not accept params.", destination);
		}
		vc = [[class alloc] init];
		XLog(self, LogFlagInfo, @"Pushed view controller %@", destination);
	}
	
	if (delegate) {
		if ([vc respondsToSelector:@selector(setDelegate:)]) {
			[(id)vc setDelegate:delegate];
		} else {
			XLog(self, LogFlagWarn, @"Warning! Passing XNavigationServiceDelegateParam to class %@, which does not respond to setDelegate:.", destination);
		}
	}
	
	[__navigationController pushViewController:vc animated:YES];
}

+ (void)popViewControllerAnimated:(BOOL)animated {
	[__navigationController popViewControllerAnimated:animated];
}

@end