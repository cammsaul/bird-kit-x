//
//  UIButton+Expa.m
//  Expa
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Expa. All rights reserved.
//

#import "UIButton+Expa.h"

@implementation UIButton (Expa)

- (void)addTarget:(id)target action:(SEL)action {
	[self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
