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

const char * stringForLogFlag(LogFlag flag) {
	if		(flag & LogFlagVerbose)	return "Verbose";
	else if (flag & LogFlagDebug)	return "Debug";
	else if (flag & LogFlagInfo)	return "Info";
	else if (flag & LogFlagWarn)	return "Warn";
	else if (flag & LogFlagError)	return "Error";
	else return NULL;
}

const char *colorForLogFlag(LogFlag flag) {
	return	(flag & LogFlagError)   ?   XLoggingColorRed    :
			(flag & LogFlagWarn)    ?   XLoggingColorOrange :
			(flag & LogFlagInfo)	?   XLoggingColorGreen  :
			(flag & LogFlagDebug)	?	XLoggingColorPurp	:
										XLoggingColorBlue   ;
}

//**** These functions are largely duplicated because varargs don't play very nicely when passing between functions ****//

void XLog(id sender, LogFlag flag, NSString *formatString, ...) {
	if (XLogClasses && ![XLogClasses containsObject:[sender class]]) return;
	if (!(CurrentLogLevel & flag)) return;
	
	va_list argptr;
	va_start(argptr, formatString);
	NSString *logMessage = [[NSString alloc] initWithFormat:(NSString *)formatString arguments:argptr];
	va_end(argptr);
	
	logMessage = [[NSString stringWithFormat:@"[%s %s] %@", class_getName([sender class]), stringForLogFlag(flag), logMessage] copy];
	
	#if DEBUG
		@synchronized(XLogClasses) {
			printf("%s%s%s\n", colorForLogFlag(flag), [logMessage cStringUsingEncoding:NSUTF8StringEncoding], XLoggingColorReset);
		}
	#endif
	
	CLSLog(@"%@", logMessage);
}

void XLogWithTag(const char *tag, LogFlag flag, NSString *formatString, ...) {
	if (!(CurrentLogLevel & flag)) return;
	if (XLogClasses) return;
		
	va_list argptr;
	va_start(argptr, formatString);
	NSString *logMessage = [[NSString alloc] initWithFormat:(NSString *)formatString arguments:argptr];
	va_end(argptr);
	
	logMessage = [[NSString stringWithFormat:@"[%s %s] %@", tag, stringForLogFlag(flag), logMessage] copy];
	
	#if DEBUG
		@synchronized(XLogClasses) {
			printf("%s%s%s\n", colorForLogFlag(flag), [logMessage cStringUsingEncoding:NSUTF8StringEncoding], XLoggingColorReset);
		}
	#endif
	
	CLSLog(@"%@", logMessage);
}