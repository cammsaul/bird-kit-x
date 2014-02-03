//
//  XLogging.m
//  GeoTip
//
//  Created by Cameron Saul on 10/22/13.
//  Copyright (c) 2013 Series G. All rights reserved.
//

#import "XLogging.h"
#import <objc/runtime.h>

/// Support for Crashlytics
OBJC_EXTERN void CLSLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);

static int CurrentLogLevel = LogLevelInfo;
int *XLogLevel = &CurrentLogLevel;

__strong NSSet *XLogClasses = nil;

char const * const StringForLogFlag(LogFlag flag) {
	if		(flag & LogFlagVerbose)	return "Verbose";
	else if (flag & LogFlagInfo)	return "Info";
	else if (flag & LogFlagWarn)	return "Warn";
	else if (flag & LogFlagError)	return "Error";
	else return NULL;
}

//**** These functions are largely duplicated because varargs don't play very nicely when passing between functions ****//

void XLog(id sender, LogFlag flag, NSString *formatString, ...) {
	if (XLogClasses && ![XLogClasses containsObject:[sender class]]) return;
	if (!(CurrentLogLevel & flag)) return;
	
	va_list argptr;
	va_start(argptr, formatString);
	NSString *logMessage = [[NSString alloc] initWithFormat:(NSString *)formatString arguments:argptr];
	va_end(argptr);
	
	logMessage = [NSString stringWithFormat:@"[%s %s] %@", class_getName([sender class]), StringForLogFlag(flag), logMessage];
	
	#if DEBUG
		const char * const logColor =   (flag & LogFlagError)   ?   XLoggingColorRed    :
		(flag & LogFlagWarn)    ?   XLoggingColorOrange :
		(flag & LogLevelInfo)   ?   XLoggingColorGreen  :
		XLoggingColorBlue   ;
		@synchronized(XLogClasses) {
			printf("%s%s%s\n", logColor, [logMessage cStringUsingEncoding:NSUTF8StringEncoding], XLoggingColorReset);
		}
	#endif
	
	CLSLog(@"%@", logMessage);
}

void XLogWithTag(const char *tag, LogFlag flag, NSString *formatString, ...) {
	if (!(CurrentLogLevel & flag)) return;
		
	va_list argptr;
	va_start(argptr, formatString);
	NSString *logMessage = [[NSString alloc] initWithFormat:(NSString *)formatString arguments:argptr];
	va_end(argptr);
	
	logMessage = [NSString stringWithFormat:@"[%s %s] %@", tag, StringForLogFlag(flag), logMessage];
	
	#if DEBUG
		const char * const logColor =   (flag & LogFlagError)   ?   XLoggingColorRed    :
										(flag & LogFlagWarn)    ?   XLoggingColorOrange :
										(flag & LogLevelInfo)   ?   XLoggingColorGreen  :
																	XLoggingColorBlue   ;
		@synchronized(XLogClasses) {
			printf("%s%s%s\n", logColor, [logMessage cStringUsingEncoding:NSUTF8StringEncoding], XLoggingColorReset);
		}
	#endif
	
	CLSLog(@"%@", logMessage);
}