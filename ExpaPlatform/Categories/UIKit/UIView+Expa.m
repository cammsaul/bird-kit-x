//
//  UIView+Expa.m
//  Expa
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Expa. All rights reserved.
//

#import "UIView+Expa.h"
#import "NSLayoutConstraint+Expa.h"
#import "UIButton+Expa.h"
#import <objc/runtime.h>

static char HiddenButtonKey;
static char LoadingSpinnerKey;
static char ShowsLoadingSpinnerKey;

@implementation UIView (Expa)

- (CGPoint)origin {
	return self.frame.origin;
}

- (CGFloat)xOrigin {
	return self.frame.origin.x;
}

- (CGFloat)yOrigin {
	return self.frame.origin.y;
}

- (CGFloat)maxX {
	return self.frame.origin.x + self.bounds.size.width;
}

- (CGFloat)maxY {
	return self.frame.origin.y + self.bounds.size.height;
}

- (CGFloat)centerX {
	return self.center.x;
}

- (CGFloat)centerY {
	return self.center.y;
}

- (CGPoint)boundsCenter {
	return CGPointMake(self.halfWidth, self.halfHeight);
}

- (CGFloat)halfWidth {
	return roundf(self.width / 2.0);
}
- (CGFloat)halfHeight {
	return roundf(self.height / 2.0);
}

- (CGSize)size {
	return self.bounds.size;
}

- (CGFloat)width {
	return self.bounds.size.width;
}

- (CGFloat)height {
	return self.bounds.size.height;
}

- (void)setOrigin:(CGPoint)origin {
	CGRect aFrame = self.frame;
	aFrame.origin = origin;
	self.frame = aFrame;
}

- (void)setXOrigin:(CGFloat)xOrigin {
	CGRect aFrame = self.frame;
	aFrame.origin.x = xOrigin;
	self.frame = aFrame;
}

- (void)setYOrigin:(CGFloat)yOrigin {
	CGRect aFrame = self.frame;
	aFrame.origin.y = yOrigin;
	self.frame = aFrame;
}

- (void)setCenterX:(CGFloat)centerX {
	CGPoint newCenter = self.center;
	newCenter.x = centerX;
	self.center = newCenter;
}

- (void)setCenterY:(CGFloat)centerY {
	CGPoint newCenter = self.center;
	newCenter.y = centerY;
	self.center = newCenter;
}

- (void)setSize:(CGSize)size {
	CGRect aFrame = self.frame;
	aFrame.size = size;
	self.frame = aFrame;
}

- (void)setWidth:(CGFloat)width {
	CGRect aFrame = self.frame;
	aFrame.size.width = width;
	self.frame = aFrame;
}

- (void)setHeight:(CGFloat)height {
	CGRect aFrame = self.frame;
	aFrame.size.height = height;
	self.frame = aFrame;
}

- (void)setMaxX:(CGFloat)maxX {
	CGFloat diff = maxX - self.maxX; // e.g. if we are at 300 (self.maxX) and want to move to 500 (maxX) we need to add 200 to center x point
	self.centerX = self.centerX + diff;
}

- (void)setMaxY:(CGFloat)maxY {
	CGFloat diff = maxY - self.maxY;
	self.centerY = self.centerY + diff;
}


- (CGRect)frameIfCenteredInSuperview {
	NSAssert(self.superview, @"must have a superview to call this method!");
	
	CGRect frame = self.frame;
	CGSize size = self.bounds.size;
	CGSize superviewSize = self.superview.bounds.size;
	
	frame.origin.x = round((superviewSize.width - size.width) / 2.0);
	frame.origin.y = round((superviewSize.height - size.height) / 2.0);
	
	return frame;
}

- (void)addConstraints:(NSArray *)visualFormatStrings views:(NSDictionary *)viewsDictionary {
	[self addConstraints:visualFormatStrings metrics:nil views:viewsDictionary];
}
- (void)addConstraints:(NSArray *)visualFormatStrings metrics:(NSDictionary *)metrics views:(NSDictionary *)viewsDictionary {
	if (!visualFormatStrings) return;
	
	for (UIView *view in viewsDictionary.allValues) {
		NSAssert([self.subviews containsObject:view], @"view '%@' is not a subview of '%@'!!", view, self);
	}
	
	for (NSString *vfString in visualFormatStrings) {
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfString options:0 metrics:metrics views:viewsDictionary priority:UILayoutPriorityRequired]];
	}
}

- (void)addConstraintToCenterView:(UIView *)view {
	[self addConstraintToCenterViewHorizontally:self];
	[self addConstraintToCenterViewVertically:self];
}

- (void)addConstraintToCenterViewHorizontally:(UIView *)view {
	NSAssert([self.subviews containsObject:view], @"view '%@' is not a subview of '%@'!!", view, self);
	[self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX equalToSameAttributeOfItem:self multiplier:1 constant:0]];
}
- (void)addConstraintToCenterViewVertically:(UIView *)view {
	NSAssert([self.subviews containsObject:view], @"view '%@' is not a subview of '%@'!!", view, self);
	[self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY equalToSameAttributeOfItem:self multiplier:1 constant:0]];
}


- (void)setBorderColor:(UIColor *)color {
	self.layer.borderColor = color.CGColor;
}

- (void)setBorderWidth:(CGFloat)width {
	self.layer.borderWidth = width;
}

- (UIButton *)hiddenButton {
	return objc_getAssociatedObject(self, &HiddenButtonKey);
}

/// also removes old hidden button from superview
- (void)setHiddenButton:(UIButton *)hiddenButton {
	[self.hiddenButton removeFromSuperview];
	objc_setAssociatedObject(self, &HiddenButtonKey, hiddenButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)addHiddenButton {
	if (self.hiddenButton) {
		[self bringSubviewToFront:self.hiddenButton];
		return;
	}
	
	self.hiddenButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.hiddenButton.frame = self.bounds;
	self.hiddenButton.autoresizingMask = UIViewAutoresizingFlexibleSize;
	[self addSubview:self.hiddenButton];
		
	[self.hiddenButton addTarget:self action:@selector(hiddenButtonPressed)];

	[self hiddenButtonAdded];
}

- (void)hiddenButtonAdded {}

- (void)removeHiddenButton {
	self.hiddenButton = nil;
}

- (void)hiddenButtonPressed {
	[self removeHiddenButton];
	[self hideKeyboard];
}

- (void)hideKeyboard {
	[self resignFirstResponder];
	for (UIView *subview in self.subviews) {
		[subview hideKeyboard];
	}
	[self keyboardDidHide];
}

- (void)keyboardDidHide {}

- (void)removeAllSubviews {
	for (UIView *subview in [self.subviews copy]) {
		[subview removeFromSuperview];
	}
}

- (void)removeSubviewWithTag:(int)tag {
	for (UIView *subview in [self.subviews copy]) {
		if (subview.tag == tag) {
			[subview removeFromSuperview];
		}
	}
}


#pragma mark - Loading Spinner

- (BOOL)showsLoadingSpinner {
	return [objc_getAssociatedObject(self, &ShowsLoadingSpinnerKey) boolValue];
}

- (UIActivityIndicatorView *)loadingSpinner {
	return objc_getAssociatedObject(self, &LoadingSpinnerKey);
}

- (void)setShowsLoadingSpinner:(BOOL)showsSpinner {
	if (showsSpinner == self.showsLoadingSpinner) return;
	
	NSAssert(NSThread.isMainThread, @"UI updates need to be done in the main thread!");
	UIActivityIndicatorView *loadingSpinner = self.loadingSpinner;
	
	if (showsSpinner) {
		if (!loadingSpinner) {
			loadingSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
			loadingSpinner.frame = self.bounds;
			loadingSpinner.translatesAutoresizingMaskIntoConstraints = NO;
			[self addSubview:loadingSpinner];
			[self addConstraints:@[@"|[loadingSpinner]|", @"V:|[loadingSpinner]|"] views:NSDictionaryOfVariableBindings(loadingSpinner)];
			objc_setAssociatedObject(self, &LoadingSpinnerKey, loadingSpinner, OBJC_ASSOCIATION_ASSIGN);
		}
		[loadingSpinner startAnimating];
		loadingSpinner.hidden = NO;
	} else {
		[loadingSpinner stopAnimating];
		loadingSpinner.hidden = YES;
	}
	objc_setAssociatedObject(self, &ShowsLoadingSpinnerKey, @(showsSpinner), OBJC_ASSOCIATION_ASSIGN);
}


#pragma mark - 3D Animation

+ (void)apply3DTransform:(CATransform3D)transform toView:(UIView *)view duration:(CGFloat)duration completion:(Transform3DCompletionBlock)completion {
	CALayer *layer = view.layer;
	
	if (duration > 0) {
		[CATransaction begin];
		[CATransaction setDisableActions:YES];
		
		CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
		animation.duration = duration;
		animation.fromValue = [NSValue valueWithCATransform3D:layer.transform];
		animation.toValue = [NSValue valueWithCATransform3D:transform];
		animation.fillMode = kCAFillModeBoth;
		[layer addAnimation:animation forKey:@"transfom"];
		
		layer.transform = transform;
		
		[CATransaction commit];
		
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC));
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			if (completion) completion();
		});
	} else {
		layer.transform = transform;
		if (completion) completion();
	}
}


@end
