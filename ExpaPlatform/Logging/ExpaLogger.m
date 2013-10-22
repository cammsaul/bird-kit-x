//
//  ExpaLogger.m
//  GeoTip
//
//  Created by Cameron Saul on 10/22/13.
//  Copyright (c) 2013 Series G. All rights reserved.
//

#import "ExpaLogger.h"

static int CurrentLogLevel = LogLevelInfo;
int *XLogLevel = &CurrentLogLevel;

__strong NSSet *XLogClasses = nil;

char const * const StringForLogFlag(LogFlag flag) {
	if		(flag & LogFlagVerbose)	return "Verbose";
	else if (flag & LogFlagInfo)		return "Info";
	else if (flag & LogFlagWarn)		return "Warn";
	else if (flag & LogFlagError)	return "Error";
	else return NULL;
}

#if DEBUG
	void XLog(id sender, LogFlag flag, NSString *formatString, ...) {
		if (!CurrentLogLevel & flag) return;
		if (XLogClasses && ![XLogClasses containsObject:[sender class]]) return;
		
		va_list argptr;
		va_start(argptr, formatString);
		NSString *string = [[NSString alloc] initWithFormat:(NSString *)formatString arguments:argptr];
		printf("[%s %s] %s\n",
			   [NSStringFromClass([sender class]) cStringUsingEncoding:NSUTF8StringEncoding],
			   StringForLogFlag(flag),
			   [string cStringUsingEncoding:NSUTF8StringEncoding]);
		va_end(argptr);
	}
#else
	// empty inline function, hopefully compiler will optimize out this entire call
	inline void XLog(id sender, LogFlag flag, NSString *formatString, ...) {}
#endif