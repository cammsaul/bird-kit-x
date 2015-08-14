//
//  XTouchView.h
//  XPlatform
//
//  Created by Cameron T Saul on 8/14/15.
//  Copyright (c) 2015 Cam Saül. All rights reserved.
//

@class XTouchView;

@protocol XTouchViewDelegate <NSObject>

- (void)touchViewWasTouched:(XTouchView *)view;

@end

/// Improved version of the "hidden button" pattern.
/// The view detects touches but allows you to specify a list of views where touches should "pass through".
@interface XTouchView : UIView

@property (nonatomic, weak) id<XTouchViewDelegate> delegate;

/// array of views to allow touches to pass through to. This array is copied when set
/// and only weak references to the views are kept.
@property (nonatomic, copy) NSArray *excludedViews;

/// Should this view automatically be removed from its superview after it's touched? (default is YES)
@property (nonatomic) BOOL removeAfterTouch;

/// When enabled, draw color-coded overlays to show what parts of the view are covered & excluded by the touch view.
@property (nonatomic) BOOL enableDebugDrawing;

+ (XTouchView *)touchViewWithExcludedViews:(NSArray *)excludedViews;

+ (XTouchView *)addTouchViewToView:(UIView *)view excludedViews:(NSArray *)excludedViews delegate:(id<XTouchViewDelegate>)delegate;

@end

