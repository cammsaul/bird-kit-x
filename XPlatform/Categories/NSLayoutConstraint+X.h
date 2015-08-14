//  -*-ObjC-*-
//  NSLayoutConstraint+X.h
//  Cam Saül
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Cam Saül. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSLayoutConstraint (X)

+ (NSArray *)constraintsWithVisualFormat:(NSString *)format options:(NSLayoutFormatOptions)opts metrics:(NSDictionary *)metrics views:(NSDictionary *)views priority:(UILayoutPriority)priority;

+ (id)constraintWithItem:(id)view1 attribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation multiplier:(CGFloat)multiplier constant:(CGFloat)constant;
+ (id)constraintWithItem:(id)view1 attribute:(NSLayoutAttribute)attr equalToSameAttributeOfItem:(id)view2 multiplier:(CGFloat)multiplier constant:(CGFloat)constant;

@end
