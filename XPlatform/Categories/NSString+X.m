//
//  NSString+X.m
//  XPlatform
//
//  Created by Ram Ravichandran on 10/24/13.
//  Copyright (c) 2013 Cam Saül. All rights reserved.
//

#import "NSString+X.h"

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

- (NSString *)base64EncodedString {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger length = [data length];
    NSMutableData *mutableData = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    
    uint8_t *input = (uint8_t *)[data bytes];
    uint8_t *output = (uint8_t *)[mutableData mutableBytes];
    
    for (NSUInteger i = 0; i < length; i += 3) {
        NSUInteger value = 0;
        for (NSUInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        static uint8_t const kAFBase64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        
        NSUInteger idx = (i / 3) * 4;
        output[idx + 0] = kAFBase64EncodingTable[(value >> 18) & 0x3F];
        output[idx + 1] = kAFBase64EncodingTable[(value >> 12) & 0x3F];
        output[idx + 2] = (i + 1) < length ? kAFBase64EncodingTable[(value >> 6)  & 0x3F] : '=';
        output[idx + 3] = (i + 2) < length ? kAFBase64EncodingTable[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:mutableData encoding:NSASCIIStringEncoding];
}

- (NSString *)stringByRemovingWhitespace {
    return [[self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@""];
}


#ifdef __cplusplus

using namespace std;

- (const string)stdString {
	return static_cast<const string>([self cStringUsingEncoding:NSUTF8StringEncoding]);
}

+ (NSString *)stringWithStdString:(const string &)stdString {
	return [NSString stringWithCString:stdString.c_str() encoding:NSUTF8StringEncoding];
}

#endif


@end
