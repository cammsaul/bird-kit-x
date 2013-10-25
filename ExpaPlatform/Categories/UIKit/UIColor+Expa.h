//
//  UIColor+Expa.h
//  ExpaPlatform
//
//  Created by Cameron Saul on 10/24/13.
//  Copyright (c) 2013 Expa, LLC. All rights reserved.
//

@interface UIColor (Expa)

/// Parses a C hex representation of a string 
+ (UIColor *)colorWithHexString:(char const * const)hexString;

@end
