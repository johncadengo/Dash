//
//  JCImageGalleryViewController.h
//  Dash
//
//  Created by John Cadengo on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
/** Keeps track of the state of the view
 */
typedef enum {
    JCImageGalleryViewStatePinhole = 0,
    JCImageGalleryViewStateGallery = 1,
    JCImageGalleryViewStateSpotlight = 2
} JCImageGalleryViewState;

@class JCImageGalleryViewController;

@protocol JCImageGalleryViewState <NSObject>

@property (nonatomic, strong) JCImageGalleryViewController *context;
@property (nonatomic, getter=amShowing) BOOL showing;

/** To ensure smooth transitions between views.
 */
- (void)prepareLayoutWithImageViews:(NSMutableArray *)imageViews;

/** Lay out its image views according to its frame.
 */
- (void)layoutImageViews:(NSMutableArray *)imageViews inFrame:(CGRect)frame;

/** Handle taps and whatnot.
 */
- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer;

/** JCViewController must show itself. Defaults with offset of zero.
 */
- (void)show;

/** Shows with an offset. For example, used for starting
    at a specific index in the spotlight view.
 */
- (void)showOffset:(NSInteger)offset;

/** JCViewController must be able to hide itself. Put away toolbars and whatnot.
 */
- (void)hide;

/**
 */
- (void)hideOffset:(NSInteger)offset;

@end

@protocol JCViewControllerDelegate <NSObject>

- (void)setState:(JCImageGalleryViewState)newState;
- (void)setState:(JCImageGalleryViewState)newState withOffset:(NSInteger)offset;

@end

@class JCViewController;
@class JCPinholeViewController;
@class JCGalleryViewController;
@class JCSpotlightViewController;

@interface JCImageGalleryViewController : UIViewController <UIGestureRecognizerDelegate, JCViewControllerDelegate>

// Things that switch
@property (nonatomic) JCImageGalleryViewState state;
@property (nonatomic, strong) JCViewController *currentViewController;
@property (nonatomic, strong) JCPinholeViewController *pinholeViewController;
@property (nonatomic, strong) JCGalleryViewController *galleryViewController;
@property (nonatomic, strong) JCSpotlightViewController *spotlightViewController;
@property (nonatomic, strong) UIGestureRecognizer *tap;

// Things that share
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *superview;
@property (nonatomic, strong) UIScrollView *view;
@property (nonatomic) CGRect frame;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *imageViews;

/** Defaults to the superview's frame.
 */
- (id)initWithImages:(NSMutableArray *)images superview:(UIView *)superview;

/** In case you want to use a frame smaller than the superview's.
 */
- (id)initWithImages:(NSMutableArray *)images superview:(UIView *)superview frame:(CGRect)frame;

/** Creates all our imageViews with the images supplied by an array
 */
- (void)setImageViewsWithImages:(NSMutableArray *)images;

/** Receive touch events and respond accordingly.
 */
- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer;

/** When we set the state variable we also change the view accordingly. Defaults to offset zero.
 */
- (void)setState:(JCImageGalleryViewState)newState;

/** When we set the state variable we also change the view accordingly.
 */
- (void)setState:(JCImageGalleryViewState)newState withOffset:(NSInteger)offset;

@end
