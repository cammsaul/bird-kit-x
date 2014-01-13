//
//  XLogging.h
//  GeoTip
//
//  Created by Cameron Saul on 10/22/13.
//  Copyright (c) 2013 Series G. All rights reserved.
//
// Now with support for color logging!
// Install the Xcode plugin by following the directions here: https://github.com/robbiehanson/XcodeColors

@import Foundation;

#define XLOGGING_COLOR_ESCAPE  "\033["
static const char * const XLoggingColorReset    = XLOGGING_COLOR_ESCAPE "fg;";
static const char * const XLoggingColorRed      = XLOGGING_COLOR_ESCAPE "fg255,0,0;";
static const char * const XLoggingColorOrange   = XLOGGING_COLOR_ESCAPE "fg200,100,0;";
static const char * const XLoggingColorGreen    = XLOGGING_COLOR_ESCAPE "fg0,180,0;";
static const char * const XLoggingColorBlue     = XLOGGING_COLOR_ESCAPE "fg0,0,200;";
static const char * const XLoggingColorPink     = XLOGGING_COLOR_ESCAPE "fg209,57,168;";

typedef enum : NSUInteger {
	LogFlagError	= 1 << 0, // 1 = 0001
	LogFlagWarn		= 1 << 1, // 2 = 0010
	LogFlagInfo		= 1 << 2, // 4 = 0100
	LogFlagVerbose	= 1 << 3, // 8 = 1000
} LogFlag;

void XLog(id sender, LogFlag flag, NSString *formatString, ...);

typedef enum : NSUInteger {
	LogLevelError	= 1,		// 0001
	LogLevelWarn	= 3,		// 0011
	LogLevelInfo	= 7,		// 0111
	LogLevelVerbose	= 15,		// 1111
} LogLevel;

/// Change this value to set the logging level for the app (e.g., you may want to set it to 0 for production builds). Default is LogLevelInfo.
/// Note you may also use category flags as part of this bitmask, e.g. LogLevelWarn|LogLevelAPI (show errors, warnings, and everything in the API category)
extern int *XLogLevel;

/// Set of class objects that should be logged. If this value is set to nil (default), every class will be logged; otherwise only classes in the set will be logged
/// (useful for debugging a specific class or set of classes)
extern NSSet *XLogClasses;
