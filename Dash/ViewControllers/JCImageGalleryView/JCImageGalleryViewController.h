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

/** Called before layout, to prepare smooth transitions.
 */
- (void)willLayoutWithOffset:(NSInteger)offset;

/** Called during transition. Animated.
 */
- (void)layoutWithOffset:(NSInteger)offset;

/** Called after layout. To fix everything in place thats not in view.
 */
- (void)didLayoutWithOffset:(NSInteger)offset;

/** Handle single taps.
 */
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer;

/** Handle double taps.
 */
- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress;

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
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

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
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer;

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress;

/** When we set the state variable we also change the view accordingly. Defaults to offset zero.
 */
- (void)setState:(JCImageGalleryViewState)newState;

/** When we set the state variable we also change the view accordingly.
 */
- (void)setState:(JCImageGalleryViewState)newState withOffset:(NSInteger)offset;

@end
