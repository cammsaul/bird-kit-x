//
//  UIColor+Expa.h
//  ExpaPlatform
//
//  Created by Cameron Saul on 10/24/13.
//  Copyright (c) 2013 Expa, LLC. All rights reserved.
//

/// Utility methods for UIColor
@interface UIColor (Expa)

/// Parses a C string hex representation of a color (3 or 6 digits), with or without prefix #
/// @param hexString a c string, e.g. "#FF0423", "FF1122", or "#123"
+ (UIColor *)colorWithHexString:(const char *)hexString;

@end
