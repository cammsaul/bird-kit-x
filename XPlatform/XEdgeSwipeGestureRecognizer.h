//
//  BKEdgeSwipeGestureRecognizer.h
//  Cam Saül
//
//  Created by Cameron Saul on 6/13/13.
//  Copyright (c) 2013 Cam Saül. All rights reserved.
//

@import UIKit;

#import <UIKit/UIGestureRecognizerSubclass.h>

@interface BKEdgeSwipeGestureRecognizer : UIGestureRecognizer

@property (nonatomic, readwrite) NSUInteger minimumNumberOfTouches; // default is 1
@property (nonatomic, readwrite) NSUInteger maximumNumberOfTouches; // default is 1

@property (nonatomic, readwrite) NSUInteger edgeThreshold; // default is 40. If user is not within [edgeThreshold] of the edge of the screen when they start the swipe, then ignore it.
@property (nonatomic, readwrite) CGFloat edgeAmount; // default is 0.4. This is the amount of each edge in which to recognize a swipe (e.g., only recognize a swipe from the middle 40% of any edge)

- (UISwipeGestureRecognizerDirection)swipeDirection; // direction of the edge swipe, or NSNotFound if none or invalid
- (CGFloat)swipeAmount; // amount of the swipe
- (CGFloat)absoulteSwipeAmount; // this is always the absolute amount of the swipe, regardless of whether it is technically a negative swipe

@end
