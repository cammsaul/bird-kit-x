//
//  UIColor+Expa.m
//  ExpaPlatform
//
//  Created by Cameron Saul on 10/24/13.
//  Copyright (c) 2013 Expa, LLC. All rights reserved.
//

#import "UIColor+Expa.h"

@implementation UIColor (Expa)

+ (UIColor *)colorWithHexString:(char const * const)hexString {
	if (hexString[0] == '#') return [UIColor colorWithHexString:&hexString[1]]; // recurse if we start with a "#"
	
	const int ele_len = strnlen(hexString, 8) <= 4 ? 1 : 2;
	int colors[3]; // RGB
	
	sscanf(hexString, (ele_len == 2 ? "%2x%2x%2x" : "%1x%1x%1x"), &colors[0], &colors[1], &colors[2]);
	return [UIColor colorWithRed:(colors[0]/256.0) green:(colors[1]/256.0) blue:(colors[2]/256.0) alpha:1];
}

@end
