//
//  JCViewController.h
//  
//
//  Created by John Cadengo on 11/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCImageGalleryViewController.h"

@interface JCViewController : UIViewController <JCImageGalleryViewState>

@property (nonatomic, strong) JCImageGalleryViewController *delegate;

@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, getter=isToolbarVisible) BOOL toolbarVisible;
@property (nonatomic, strong) UIBarButtonItem *done;


- (id)initWithImages:(NSMutableArray *) images superview:(UIView *)superview frame:(CGRect)frame;

/** If we tap the pinhole, we need to transform to the spotlight view and
    zoom in on the appropriate picture.
 */
/** If we tap the spotlight view we need to toggle the toolbars.
 */
- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer;

/**
 */
- (void)show;

/** Called in the spotlight view to turn the toolbar visible and hidden.
 */
- (void)toggleToolbar;

/** Called when the done button is pushed. Will return us back to the pinhole view.
 */
- (void)handleDone:(id)sender;

@end
