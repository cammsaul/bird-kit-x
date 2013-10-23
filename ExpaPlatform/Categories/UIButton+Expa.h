//  -*-ObjC-*-
//  UIButton+Expa.h
//  Expa
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Expa. All rights reserved.
//

@import UIKit;

@interface UIButton (Expa)

/// shorthand so you don't need to type out the action since 99.99% of the time we want TouchUpInside
- (void)addTarget:(id)target action:(SEL)action;

@end
