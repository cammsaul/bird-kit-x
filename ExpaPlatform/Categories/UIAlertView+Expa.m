//
//  UIAlertView+Expa.m
//  Expa
//
//  Created by Cameron Saul on 7/10/13.
//  Copyright (c) 2013 Expa. All rights reserved.
//

#import "UIAlertView+Expa.h"
#import "XLogging.h"
#import "XGCDUtilites.h"
#import <objc/runtime.h>

static char AlertViewButtonPressedBlockKey;

@implementation UIAlertView (Expa)

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle {
	if (!NSThread.isMainThread) {
		dispatch_async_main(^{
			XLog(UIAlertView.class, LogFlagWarn, @"Attempted to show alert on background thread. Showing on main thread.", title, message);
			[self showAlertWithTitle:title message:message cancelButtonTitle:cancelButtonTitle];
		});
		return;
	}
	XLog(UIAlertView.class, LogFlagInfo, @"Showing alert: Title: %@, Message: %@\n", title, message);
	[[[self alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil] show];
}

+ (void)showAlertWithTitle:(NSString *)title
				   message:(NSString *)message
		buttonPressedBlock:(AlertViewButtonPressedBlock)buttonPressedBlock
		 cancelButtonTitle:(NSString *)cancelButtonTitle
		 otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION {
	
	UIAlertView *alertView = [[self alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
	
	if (otherButtonTitles) {
		va_list args;
		va_start(args, otherButtonTitles);
		NSString *otherButtonTitle = otherButtonTitles; // the first arg
		do {
			if (otherButtonTitle) [alertView addButtonWithTitle:otherButtonTitle];
		} while ((otherButtonTitle = va_arg(args, NSString *)) != nil);
		va_end(args);
	}
	
	if (buttonPressedBlock) {
		alertView.delegate = alertView;
		objc_setAssociatedObject(alertView, &AlertViewButtonPressedBlockKey, buttonPressedBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
	}
	
	if (!NSThread.isMainThread) {
		dispatch_async_main(^{
			[alertView show];
		});
	} else {
		[alertView show];
	}
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	AlertViewButtonPressedBlock block = objc_getAssociatedObject(alertView, &AlertViewButtonPressedBlockKey);
	if (block) block(buttonIndex == self.cancelButtonIndex, buttonIndex);
}

@end
