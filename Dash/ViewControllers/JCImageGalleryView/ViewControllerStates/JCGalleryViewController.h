//
//  JCGalleryViewController.h
//  Dash
//
//  Created by John Cadengo on 11/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCViewController.h"

@interface JCGalleryViewController : JCViewController <JCImageGalleryViewState>

@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIBarButtonItem *done;

/** Let's keep track of our imageview frames so we can know if they were touched
 */
@property (nonatomic, strong) NSMutableArray *imageViewFrames;

/** Called when the done button is pushed. Will return us back to the pinhole view.
 */
- (void)handleDone:(id)sender;

@end
