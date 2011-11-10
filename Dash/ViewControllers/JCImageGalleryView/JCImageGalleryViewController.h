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
    JCImageGalleryViewStatePinhole = 0,     // Embed this in another view
    JCImageGalleryViewStateGallery = 1,     // Shows images categorized by album
    JCImageGalleryViewStateSpotlight = 2    // Shows a single image
} JCImageGalleryViewState;

@interface JCImageGalleryViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *superview;
@property (nonatomic, strong) UIGestureRecognizer *tap;
@property (nonatomic, strong) UIScrollView *view;
@property (nonatomic) CGRect frame;
@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, getter=isToolbarVisible) BOOL toolbarVisible;
@property (nonatomic, strong) UIBarButtonItem *done;
@property (nonatomic) JCImageGalleryViewState state;

/** Defaults to the superview's frame.
 */
- (id)initWithImages:(NSArray *) images superview:(UIView *)superview;

/** In case you want to use a frame smaller than the superview's.
 */
- (id)initWithImages:(NSArray *) images superview:(UIView *)superview frame:(CGRect)frame;

/** Receive touch events and respond accordingly.
 */
- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer;

/** If we tap the pinhole, we need to transform to the spotlight view and
    zoom in on the appropriate picture.
 */
- (void)handlePinholeTap:(UIGestureRecognizer *)gestureRecognizer;

/** If we tap the spotlight view we need to toggle the toolbars.
 */
- (void)handleSpotlightTap:(UIGestureRecognizer *)gestureRecognizer;

/** When we set the state variable we also change the view accordingly.
 */
- (void)setState:(JCImageGalleryViewState)state;

/** Called when a state change occurs where the new state is pinhole view.
    Returns to the pinhole view when the done button is tapped on the toolbar.
 */
- (void)showPinholeView;

/** Called when a state change occurs where the new state is spotlight view.
    Called from the pinhole view when an image is tapped.
 */
- (void)showSpotlightView;

/** Called in the spotlight view to turn the toolbar visible and hidden.
 */
- (void)toggleToolbar;

/** Called when the done button is pushed. Will return us back to the pinhole view.
 */
- (void)handleDone:(id)sender;

@end
