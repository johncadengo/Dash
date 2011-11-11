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

@protocol JCImageGalleryViewState <NSObject>

- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer;
- (void)show;

@end

@protocol JCViewControllerDelegate <NSObject>

- (void)setState:(JCImageGalleryViewState)newState;

@end

@class JCViewController;
@class JCPinholeViewController;
@class JCGalleryViewController;
@class JCSpotlightViewController;

@interface JCImageGalleryViewController : UIViewController <UIGestureRecognizerDelegate, JCViewControllerDelegate>

@property (nonatomic) JCImageGalleryViewState state;
@property (nonatomic, strong) JCViewController *currentViewController;
@property (nonatomic, strong) JCPinholeViewController *pinholeViewController;
@property (nonatomic, strong) JCGalleryViewController *galleryViewController;
@property (nonatomic, strong) JCSpotlightViewController *spotlightViewController;
@property (nonatomic, strong) UIGestureRecognizer *tap;

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

/** When we set the state variable we also change the view accordingly.
 */
- (void)setState:(JCImageGalleryViewState)newState;

/** Lays out the image views acording to our current state.
 */
- (void)layoutImageViews;

@end
