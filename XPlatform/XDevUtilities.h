//
//  XDevUtilities.h
//  XPlatform
//
//  Created by Cameron Saul on 10/24/13.
//  Copyright (c) 2013 Cam Saül. All rights reserved.
//

/// Simple way to show an alert with a format string as a TODO reminder. Logs the TODO as well.
void TodoAlert(NSString *formatString, ...);

/// Simple function to show an error alert view and log the error, if error is non-nil.
/// You may optionally provide additional info with the vararg format string.
/// Unlike ErrorAlert, formatString is optional.
/// \seealso ErrorAlert
void AlertIfError(id sender, NSError *error, NSString *formatStringOrNil, ...);

/// Shows an error alert view and logs the error. Unlike AlertIfError, error is optional; message
/// and logging will always take place.
/// This method generally shouldn't be used in production, since there is no localization
/// and the error messages are probably not always user friendly.
/// \seealso AlertIfError
void ErrorAlert(id sender, NSError *errorOrNil, NSString *formatString, ...);