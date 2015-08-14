//
//  XTouchView.m
//  XPlatform
//
//  Created by Cameron T Saul on 8/14/15.
//  Copyright (c) 2015 Cam Saül. All rights reserved.
//

//#import "UIView+X.h"
#import "XTouchView.h"

@interface XTouchViewWeakRef : NSObject
@property (nonatomic, weak) UIView *view;
@end

@implementation XTouchViewWeakRef
@end

@implementation XTouchView

+ (XTouchView *)touchViewWithExcludedViews:(NSArray *)excludedViews {
    XTouchView *touchView = [[XTouchView alloc] init];
    touchView.excludedViews = excludedViews;
    return touchView;
}

+ (XTouchView *)addTouchViewToView:(UIView *)view excludedViews:(NSArray *)excludedViews delegate:(id<XTouchViewDelegate>)delegate {
    XTouchView *touchView = [XTouchView touchViewWithExcludedViews:excludedViews];
    touchView.delegate = delegate;
  
    touchView.frame = view.bounds;
    [view addSubview:touchView];
//    [view addConstraints:@[@"|[touchView]|", @"V:|[touchView]|"] views:NSDictionaryOfVariableBindings(touchView)];
    
    return touchView;
}

- (instancetype)init  {
    if (self = [super init]) {
        self.removeAfterTouch = YES;
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        self.clearsContextBeforeDrawing = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    if (!self.enableDebugDrawing) return;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(c, [UIColor colorWithRed:0 green:1.0f blue:0 alpha:0.2f].CGColor);
    CGContextFillRect(c, rect);
    
    CGContextSetFillColorWithColor(c, [UIColor colorWithRed:1.0f green:0 blue:0 alpha:0.2f].CGColor);
    for (XTouchViewWeakRef *weakRef in self.excludedViews) {
        UIView *view = weakRef.view;
        if (!view) continue;
        
        CGContextFillRect(c, [self convertRect:view.bounds fromView:view]);
    }
}

- (void)setExcludedViews:(NSArray *)excludedViews {
    NSMutableArray *mExcludedViews = [NSMutableArray arrayWithCapacity:excludedViews.count];
    
    for (UIView *view in excludedViews) {
        XTouchViewWeakRef *weakRef = [[XTouchViewWeakRef alloc] init];
        weakRef.view = view;
        [mExcludedViews addObject:weakRef];
    }
    
    _excludedViews = mExcludedViews;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	for (UITouch *touch in touches) {
		if ((self == touch.view) && (self == [self hitTest:[touch locationInView:self]  withEvent:nil])) {
            // strong ref so we don't get dealloc'ed before we call our delegate
            XTouchView *touchView = self;
            [touchView removeFromSuperview];
            [touchView.delegate touchViewWasTouched:touchView];
			return;
		}
	}
	
	[super touchesEnded:touches withEvent:event];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    for (XTouchViewWeakRef *weakRef in self.excludedViews) {
        UIView *view = weakRef.view;
        if (!view) continue;
        
        if (CGRectContainsPoint([self convertRect:view.bounds fromView:view], point)) {
            return [view hitTest:[self convertPoint:point toView:view] withEvent:event];
        }
    }
    
	return [super hitTest:point withEvent:event];
}

@end
