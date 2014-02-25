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

dispatch_queue_t loggingDispatchQueue() {
	@synchronized(XLogClasses) {
		static dispatch_queue_t __loggingDispatchQueue;
		
		if (!__loggingDispatchQueue) {
			__loggingDispatchQueue = dispatch_queue_create("com.expa.loggingDispatchQueue", DISPATCH_QUEUE_SERIAL);
			__xLogString = [NSMutableString string];
		}
		
		return __loggingDispatchQueue;
	}
}

void logMessage(const char *tag, LogFlag flag, NSString *_message) {
	dispatch_async(loggingDispatchQueue(), ^{
		NSString *message = [NSString stringWithFormat:@"[%s %s] %@", tag, stringForLogFlag(flag), _message];
		
		printf("%s%s%s\n", colorForLogFlag(flag), [message cStringUsingEncoding:NSUTF8StringEncoding], XLoggingColorReset);
		
		[__xLogString appendFormat:@"%@\n\n", message];
		
		CLSLog(@"%@", message);
	});
}

NSString *XLogApplicationLog() {
	__block NSString *logStr;
	dispatch_sync(loggingDispatchQueue(), ^{
		logStr = [__xLogString copy];
	});
	return logStr;
}