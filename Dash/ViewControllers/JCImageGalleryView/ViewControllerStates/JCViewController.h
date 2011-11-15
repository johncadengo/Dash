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

/** Must be able to know what to do with gestures.
 */
- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer;

/** Needs to be able to show itself.
 */
- (void)show;

/** 
 */
- (void)showOffset:(NSInteger)offset;

/** Called when we are leaving this view.
 */
- (void)hide;

- (void)hideOffset:(NSInteger)offset;

@end
