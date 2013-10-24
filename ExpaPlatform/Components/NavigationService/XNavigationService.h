//
//  XNavigationService.h
//  Expa
//
//  Created by Cameron Saul on 3/22/13.
//  Copyright (c) 2013 Expa. All rights reserved.
//

@import Foundation;
@import UIKit;

/// this parameter is a special case; if you set this parameter and the target view controller responds to setDelegate:,
/// then setDelegate: will be called with the value when that view controller is pushed.
extern const NSString *XNavigationServiceDelegateParam;

/// Simple navigation service that supports navigating to different pages of the app with parameters, similar to Android
/// activities or web navigation.
@interface XNavigationService : NSObject

/// Navigaties to the view controller with the provided name. Automatically calls initWithParams: if the view controller
/// supports it, which sets the params property of that view controller.
/// Automatically logs the navigation and passed params.
+ (void)navigateTo:(NSString *)destinationClassName params:(NSDictionary *)params;

/// Pops the top view controller.
+ (void)popViewControllerAnimated:(BOOL)animated;

/// This method should be called on app launch or whenever a new navigation controller comes into use. XNavigationService will use
/// this navigation controller internally to push and pop view controllers.
+ (void)setNavigationController:(UINavigationController *)navigationController;

@end

@protocol InitWithParams <NSObject>
/// Called automagically by [XNavigationService navigateTo:params:] if this method is implemented. XViewController implements this method,
/// And the default implementation just sets self.params.
/// Subclasses of XViewController should override [super initWithParams:] rather than init: or initWithNibNamed:.
- (id)initWithParams:(NSDictionary *)params;
@optional
/// You may optionally implement this method and do validation of the parameters passed to the view controller. This method is called, if it exists,
/// whenever the view controller is pushed. Use NSAssert to do simple parameter checking.
+ (void)validateParams:(NSDictionary *)params;
@end