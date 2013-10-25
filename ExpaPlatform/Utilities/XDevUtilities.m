//
//  XDevUtilities.m
//  ExpaPlatform
//
//  Created by Cameron Saul on 10/24/13.
//  Copyright (c) 2013 Expa, LLC. All rights reserved.
//

#import "XDevUtilities.h"
#import "UIAlertView+Expa.h"
#import "XLogging.h"

void TodoAlert(NSString *formatString, ...) {
	va_list argptr;
	va_start(argptr, formatString);
	NSString *message = [[NSString alloc] initWithFormat:formatString arguments:argptr];
	[UIAlertView showAlertWithTitle:@"TODO" message:message cancelButtonTitle:@"Ok"];
	va_end(argptr);
}

void AlertIfError(id sender, NSError *error, NSString *formatString, ...) {
	if (!error) return;
	
	if (!formatString) {
		[UIAlertView showAlertWithTitle:@"Error" message:error.localizedDescription cancelButtonTitle:@"Ok"];
		XLog(sender, LogFlagError, @"%@", error.localizedDescription);
		return;
	}
	
	va_list argptr;
	va_start(argptr, formatString);
	NSString *message = [NSString stringWithFormat:@"%@ %@", [[NSString alloc] initWithFormat:formatString arguments:argptr], error.localizedDescription];
	[UIAlertView showAlertWithTitle:@"Error" message:message cancelButtonTitle:@"Ok"];
	XLog(sender, LogFlagError, @"%@", message);
	
}

void ErrorAlert(id sender, NSError *errorOrNil, NSString *formatString, ...) {
	va_list argptr;
	va_start(argptr, formatString);
	NSString *message = [[NSString alloc] initWithFormat:formatString arguments:argptr];
	if (errorOrNil) message = [message stringByAppendingFormat:@" %@", errorOrNil.localizedDescription];
	[UIAlertView showAlertWithTitle:@"Error" message:message cancelButtonTitle:@"Ok"];
	XLog(sender, LogFlagError, @"%@", message);
}