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

@property (nonatomic, strong) JCImageGalleryViewController *context;
@property (nonatomic, getter=amShowing) BOOL showing;

/** JCViewController is useless without a delegate. Must call this init statement.
 */
- (id)initWithContext:(id)context;

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
