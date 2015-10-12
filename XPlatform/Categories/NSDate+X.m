//
//  NSDate+X.m
//  XPlatform
//
//  Created by Cam Saül on 5/19/15.
//  Copyright (c) Cam Saül. All rights reserved.
//

#import "NSDate+X.h"

@implementation NSDate (X)

+ (NSDate *)dateFromRFC3339String:(NSString *)string {
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    dateFormatter.locale            = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat        = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'";
    dateFormatter.timeZone          = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    return [dateFormatter dateFromString:string];
}

- (NSString *)RFC3339String {
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    dateFormatter.locale            = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat        = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'";
    dateFormatter.timeZone          = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    return [dateFormatter stringFromDate:self];
}

- (NSDateComponents *)components:(NSCalendarUnit)unitFlags {
    return [[NSCalendar currentCalendar] components:unitFlags fromDate:self];
}

- (NSInteger)day {
    return [self components:NSDayCalendarUnit].day;
}

- (NSInteger)month {
    return [self components:NSMonthCalendarUnit].month;
}

- (NSInteger)year {
    return [self components:NSYearCalendarUnit].year;
}

- (NSString *)monthName {
    return [[NSCalendar currentCalendar] monthSymbols][self.month - 1];
}

- (NSString *)weekdayName {
    NSInteger weekday = [self components:NSWeekdayCalendarUnit].weekday;      // starts at 1
    return [[NSCalendar currentCalendar] weekdaySymbols][weekday - 1];
}

@end
