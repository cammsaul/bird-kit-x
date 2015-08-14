//  -*-ObjC-*-
//  UIButton+X.h
//  Cam Saül
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Cam Saül. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (X)

/// shorthand so you don't need to type out the action since 99.99% of the time we want TouchUpInside
- (void)addTarget:(id)target action:(SEL)action;

@end
