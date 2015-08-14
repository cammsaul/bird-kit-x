//
//  NSString+X.m
//  XPlatform
//
//  Created by Ram Ravichandran on 10/24/13.
//  Copyright (c) 2013 Cam Saül. All rights reserved.
//

#import "NSString+X.h"

using namespace std;

@implementation NSString (X)

-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
	return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                               (CFStringRef)self,
                                                               NULL,
                                                               (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                               CFStringConvertNSStringEncodingToEncoding(encoding)));
}

- (NSInteger)distanceFromString:(NSString *)otherString {
	static const int Gain = 0;
	static const int Cost = 1;
	
	if (!otherString.length) return self.length;
	NSParameterAssert([otherString isKindOfClass:[NSString class]]);
	if (![otherString isKindOfClass:[NSString class]]) return NO;
	
	// normalize strings
	NSString *stringA = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
	NSString *stringB = [[otherString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
	
	// Step 1
	NSInteger k, i, j, change, *d, distance;
	
	NSUInteger n = [stringA length];
	NSUInteger m = [stringB length];
	
	if( n++ != 0 && m++ != 0 ) {
		d = (NSInteger *)malloc( sizeof(NSInteger) * m * n );
		
		// Step 2
		for( k = 0; k < n; k++)
			d[k] = k;
		
		for( k = 0; k < m; k++)
			d[ k * n ] = k;
		
		// Step 3 and 4
		for( i = 1; i < n; i++ ) {
			for( j = 1; j < m; j++ ) {
				
				// Step 5
				if([stringA characterAtIndex: i-1] == [stringB characterAtIndex: j-1]) {
					change = -Gain;
				} else {
					change = Cost;
				}
				
				// Step 6
				d[ j * n + i ] = MIN(d [ (j - 1) * n + i ] + 1, MIN(d[ j * n + i - 1 ] +  1, d[ (j - 1) * n + i -1 ] + change));
			}
		}
		
		distance = d[ n * m - 1 ];
		free( d );
		return distance;
	}
	
	return 0;
}

- (const string)stdString {
	return static_cast<const string>([self cStringUsingEncoding:NSUTF8StringEncoding]);
}

+ (NSString *)stringWithStdString:(const string &)stdString {
	return [NSString stringWithCString:stdString.c_str() encoding:NSUTF8StringEncoding];
}


@end
