//
//  NSString+Expa.h
//  ExpaPlatform
//
//  Created by Ram Ravichandran on 10/24/13.
//  Copyright (c) 2013 Expa, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __cplusplus
#include <string>
#endif

@interface NSString (Expa)
-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;

#ifdef __cplusplus
/// Helper method to return a C++ std::string
- (const std::string)stdString;

/// Helper method to create an NSString from a C++ std::string
+ (NSString *)stringWithStdString:(const std::string &)stdString;
#endif

@end
