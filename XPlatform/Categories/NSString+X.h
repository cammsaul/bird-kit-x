//
//  NSString+X.h
//  XPlatform
//
//  Created by Ram Ravichandran on 10/24/13.
//  Copyright (c) 2013 Cam Saül. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __cplusplus
#include <string>
#endif

@interface NSString (X)
-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;

/// Returns edit distance of string from another
- (NSInteger)distanceFromString:(NSString *)otherString;

/// Return a Base-64 encoded version of the current string
- (NSString *)base64EncodedString;

#ifdef __cplusplus
/// Helper method to return a C++ std::string
- (const std::string)stdString;

/// Helper method to create an NSString from a C++ std::string
+ (NSString *)stringWithStdString:(const std::string &)stdString;
#endif

@end
