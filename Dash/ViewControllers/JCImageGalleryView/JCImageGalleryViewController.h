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

@interface JCImageGalleryViewController : UIViewController

@property (nonatomic, strong) UIView *superview;
@property (nonatomic, strong) UIGestureRecognizer *tap;
@property (nonatomic, strong) UIScrollView *view;
@property (nonatomic) CGRect frame;

@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIBarButtonItem *done;
@property (nonatomic) JCImageGalleryViewState state;

- (id)initWithSuperview:(UIView *)superview;
- (id)initWithSuperview:(UIView *)superview frame:(CGRect)frame;
- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer;

- (void)handlePinholeTap:(UIGestureRecognizer *)gestureRecognizer;
- (void)handleSpotlightTap:(UIGestureRecognizer *)gestureRecognizer;

- (void)showToolbar:(id)sender;
- (void)handleDone:(id)sender;

@end
