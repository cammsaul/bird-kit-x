//
//  XDevUtilities.m
//  ExpaPlatform
//
//  Created by Cameron Saul on 10/24/13.
//  Copyright (c) 2013 Expa, LLC. All rights reserved.
//

#import "XDevUtilities.h"
#import "UIAlertView+Expa.h"

void TodoAlert(NSString *formatString, ...) {
	va_list argptr;
	va_start(argptr, formatString);
	NSString *message = [[NSString alloc] initWithFormat:formatString arguments:argptr];
	[UIAlertView showAlertWithTitle:@"TODO" message:message cancelButtonTitle:@"Ok"];
	va_end(argptr);
}