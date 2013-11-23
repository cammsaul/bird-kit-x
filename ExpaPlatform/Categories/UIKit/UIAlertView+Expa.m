//
//  UIAlertView+Expa.m
//  Expa
//
//  Created by Cameron Saul on 7/10/13.
//  Copyright (c) 2013 Expa. All rights reserved.
//

#import "UIAlertView+Expa.h"
#import <objc/runtime.h>

static char AlertViewButtonPressedBlockKey;

@implementation UIAlertView (Expa)

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle {
	if (!NSThread.isMainThread) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[self showAlertWithTitle:title message:message cancelButtonTitle:cancelButtonTitle];
		});
		return;
	}
	[[[self alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil] show];
}

+ (void)showAlertWithTitle:(NSString *)title
				   message:(NSString *)message
		buttonPressedBlock:(AlertViewButtonPressedBlock)buttonPressedBlock
		 cancelButtonTitle:(NSString *)cancelButtonTitle
		 otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION {
	
	UIAlertView *alertView = [[self alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
	
	if (buttonPressedBlock) {
		alertView.delegate = alertView;
		objc_setAssociatedObject(alertView, &AlertViewButtonPressedBlockKey, buttonPressedBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
	}
	[alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	AlertViewButtonPressedBlock block = objc_getAssociatedObject(alertView, &AlertViewButtonPressedBlockKey);
	if (block) block(buttonIndex == self.cancelButtonIndex, buttonIndex);
}

@end
