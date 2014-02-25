//
//  XLogging.m
//  GeoTip
//
//  Created by Cameron Saul on 10/22/13.
//  Copyright (c) 2013 Series G. All rights reserved.
//

#import "XLogging.h"
#import <objc/runtime.h>
#import "XGCDUtilites.h"

/// Support for Crashlytics
OBJC_EXTERN void CLSLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);

static int CurrentLogLevel = LogLevelInfo;
int *XLogLevel = &CurrentLogLevel;

__strong NSSet *XLogClasses = nil;
static NSMutableString *__xLogString = nil;

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

void logMessage(const char *tag, LogFlag flag, NSString *message);

void XLog(id sender, LogFlag flag, NSString *formatString, ...) {
	if (XLogClasses && ![XLogClasses containsObject:[sender class]]) return;
	if (!(CurrentLogLevel & flag)) return;
	
	va_list argptr;
	va_start(argptr, formatString);
	NSString *message = [[NSString alloc] initWithFormat:(NSString *)formatString arguments:argptr];
	va_end(argptr);
	
	logMessage(class_getName([sender class]), flag, message);
}

void XLogWithTag(const char *tag, LogFlag flag, NSString *formatString, ...) {
	if (!(CurrentLogLevel & flag)) return;
	if (XLogClasses) return;
		
	va_list argptr;
	va_start(argptr, formatString);
	NSString *message = [[NSString alloc] initWithFormat:(NSString *)formatString arguments:argptr];
	va_end(argptr);
		
	logMessage(tag, flag, message);
}

void logMessage(const char *tag, LogFlag flag, NSString *message) {
	message = [[NSString stringWithFormat:@"[%s %s] %@", tag, stringForLogFlag(flag), message] copy];
	
	#if DEBUG
		dispatch_async_background_priority(^{
			@synchronized(XLogClasses) {
				printf("%s%s%s\n", colorForLogFlag(flag), [message cStringUsingEncoding:NSUTF8StringEncoding], XLoggingColorReset);
				
				if (!__xLogString) {
					__xLogString = [NSMutableString string];
				}
				[__xLogString appendFormat:@"%@\n\n", message];
			}
		});
	#endif
	
	CLSLog(@"%@", message);
}

NSString *XLogApplicationLog() {
	@synchronized(XLogClasses) {
		return [__xLogString copy];
	}
}