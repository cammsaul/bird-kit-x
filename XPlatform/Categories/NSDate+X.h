//
//  NSDate+X.h
//  XPlatform
//
//  Created by Cameron T Saul on 5/19/15.
//  Copyright (c) 2015 Cam Saül. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (X)

/// Parse a date with the format yyyy-MM-ddTHH:mm:ssZ
+ (NSDate *)dateFromRFC3339String:(NSString *)string;

/// Return date components using the current calendar.
- (NSDateComponents *)components:(NSCalendarUnit)unitFlags;

- (NSInteger)day;
- (NSInteger)month;
- (NSInteger)year;

- (NSString *)monthName;
- (NSString *)weekdayName;

@end
