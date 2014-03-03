//
//  NSString+Expa.m
//  ExpaPlatform
//
//  Created by Ram Ravichandran on 10/24/13.
//  Copyright (c) 2013 Expa, LLC. All rights reserved.
//

#import "NSString+Expa.h"

using namespace std;

@implementation NSString (Expa)

-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
	return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                               (CFStringRef)self,
                                                               NULL,
                                                               (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                               CFStringConvertNSStringEncodingToEncoding(encoding)));
}

- (const string)stdString {
	return static_cast<const string>([self cStringUsingEncoding:NSUTF8StringEncoding]);
}

+ (NSString *)stringWithStdString:(const string &)stdString {
	return [NSString stringWithCString:stdString.c_str() encoding:NSUTF8StringEncoding];
}


@end
