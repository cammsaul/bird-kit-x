//
//  UIButton+X.m
//  Cam Saül
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Cam Saül. All rights reserved.
//

#import "UIButton+X.h"

@implementation UIButton (X)

- (void)addTarget:(id)target action:(SEL)action {
	[self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
