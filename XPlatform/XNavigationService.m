//
//  XNavigationService.m
//  Cam Saül
//
//  Created by Cameron Saul on 3/22/13.
//  Copyright (c) 2013 Cam Saül. All rights reserved.
//

#import "XNavigationService.h"
#import "NSDictionary+X.h"
#import "XLogging.h"

@interface XNavigationService ()
@property (nonatomic, strong) UINavigationController *navigationController;
+ (XNavigationService *)sharedInstance;
@end

@implementation XNavigationService

+ (XNavigationService *)sharedInstance {
	return [super sharedInstance];
}

+ (void)setNavigationController:(UINavigationController *)navigationController {
	NSAssert(navigationController, @"You should not set navigation controller to nil!");
	XLog(self, LogFlagInfo, @"Root navigation controller set to: %@", navigationController);
	[self sharedInstance].navigationController = navigationController;
}

+ (UINavigationController *)navigationController {
	return [self sharedInstance].navigationController;
}

+ (void)navigateTo:(NSString *)destination params:(NSDictionary *)params {
	NSAssert([self sharedInstance].navigationController, @"you must call setNavigationController: before using the navigation service!");
	
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
	
    [self pushViewController:vc animated:YES];
}

+ (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	[[self sharedInstance].navigationController pushViewController:viewController animated:animated];
}

+ (void)popViewControllerAnimated:(BOOL)animated {
	[[self sharedInstance].navigationController popViewControllerAnimated:animated];
}

@end