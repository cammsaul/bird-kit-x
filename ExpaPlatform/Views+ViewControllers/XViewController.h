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

PROP_STRONG_RO NSDictionary *params;

/// Optional class method that can be used to do parameter validation.
/// Default implementation does nothing, but subclasses of XViewController can override this to validate their parameters.
/// This method is called, if it exists, whenever the view controller is pushed. Use NSAssert to do simple parameter checking.
+ (void)validateParams:(NSDictionary *)params;

/// Initializes a new XViewController with a dictionary of parameters. You should not call this directly -
/// XNavigationService will call this automatically. Subclasses of XViewController should override [super initWithParams:]
/// rather than init: or initWithNibNamed:.
- (id)initWithParams:(NSDictionary *)params;

@end
