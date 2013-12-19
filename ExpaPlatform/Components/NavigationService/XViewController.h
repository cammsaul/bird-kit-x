//
//  XViewController.h
//  GeoTip
//
//  Created by Cameron Saul on 10/17/13.
//  Copyright (c) 2013 Series G. All rights reserved.
//

#import "XNavigationService.h"

/// Common base view controller that all full-screen view controllers should inherit from.
/// Takes care of certain boilerpoint like automatically logging when VC appears.
///
/// Implements the <InitWithParams> protocol, which means you can use XNavigationService to push
/// an XViewController with [XNavigationService navigateTo:params:].
/// The params property is automatically set and logged.
@interface XViewController : UIViewController <InitWithParams>

/// A dictionary of parameters that were passed to the view controller if it was called with initWithParams
PROP_STRONG_RO NSDictionary *params;

/// Optional class method that can be used to do parameter validation.
/// Default implementation does nothing, but subclasses of XViewController can override this to validate their parameters.
/// This method is called, if it exists, whenever the view controller is pushed. Use NSAssert/NSParameterAssert to do simple parameter checking.
///
/// @param params Dictionary of parameters that is about to be passed to an instance of this class
+ (void)validateParams:(NSDictionary *)params;

/// Initializes a new XViewController with a dictionary of parameters. You should not call this directly -
/// XNavigationService will call this automatically. Subclasses of XViewController should override [super initWithParams:]
/// rather than init: or initWithNibNamed:.
///
/// @param params Dictionary of parameters to pass to the view controller
- (instancetype)initWithParams:(NSDictionary *)params;

/// This method is called whether the view controller is created with init, initWithNibName:bundle: initWithParams:, or via a nib file (awakeFromNib).
/// In any of the above cases, [self setup  is called]. You can override setup to do logic that would otherwise go in an init method (and possibly be duplicated amongst several).
/// The default implementation does nothing.
- (void)setup;

@end
