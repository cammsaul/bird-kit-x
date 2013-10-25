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

static NSString *TodoTitle = @"TODO";
static NSString *ErrorTitle = @"Error";
static NSString *ButtonText = @"Ok";

void TodoAlert(NSString *formatString, ...) {
	va_list argptr;
	va_start(argptr, formatString);
	NSString *message = [[NSString alloc] initWithFormat:formatString arguments:argptr];
	[UIAlertView showAlertWithTitle:TodoTitle message:message cancelButtonTitle:ButtonText];
	va_end(argptr);
}

void AlertIfError(id sender, NSError *error, NSString *formatString, ...) {
	if (!error) return;
	
	if (!formatString) {
		[UIAlertView showAlertWithTitle:ErrorTitle message:error.localizedDescription cancelButtonTitle:ButtonText];
		XLog(sender, LogFlagError, @"%@", error.localizedDescription);
		return;
	}
	
	va_list argptr;
	va_start(argptr, formatString);
	NSString *message = [NSString stringWithFormat:@"%@ %@", [[NSString alloc] initWithFormat:formatString arguments:argptr], error.localizedDescription];
	[UIAlertView showAlertWithTitle:ErrorTitle message:message cancelButtonTitle:ButtonText];
	XLog(sender, LogFlagError, @"%@", message);
	
}

void ErrorAlert(id sender, NSError *errorOrNil, NSString *formatString, ...) {
	// we're SUPPOSED to have a format string, but it's better to bow out gracefully in this situation rather than causing the app to crash trying to use the varargs
	if (!formatString) {
		NSString *message = errorOrNil.localizedDescription ? errorOrNil.localizedDescription : [NSString stringWithFormat:@"An error occurred in %@.", NSStringFromClass([sender class])];
		[UIAlertView showAlertWithTitle:ErrorTitle message:message cancelButtonTitle:ButtonText];
		return;
	}
	
	va_list argptr;
	va_start(argptr, formatString);
	NSString *message = [[NSString alloc] initWithFormat:formatString arguments:argptr];
	if (errorOrNil) message = [message stringByAppendingFormat:@" %@", errorOrNil.localizedDescription];
	[UIAlertView showAlertWithTitle:ErrorTitle message:message cancelButtonTitle:ButtonText];
	XLog(sender, LogFlagError, @"%@", message);
}