//
//  JCSpotlightViewController.h
//  Dash
//
//  Created by John Cadengo on 11/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCViewController.h"

@interface JCSpotlightViewController : JCViewController <JCImageGalleryViewState>

@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, getter=isToolbarVisible) BOOL toolbarVisible;
@property (nonatomic, strong) UIBarButtonItem *done;
@property (nonatomic, strong) UIBarButtonItem *seeAll; 

@property (nonatomic) NSInteger page;

/** Called in the spotlight view to turn the toolbar visible and hidden.
 */
- (void)toggleToolbar;

/** Called when the done button is pushed. Will return us back to the pinhole view.
 */
- (void)handleDone:(id)sender;

/** Called when the see all button is pushed. Will transition to the gallery view.
 */
- (void)handleSeeAll:(id)sender;

/** Calculates the origin for the page. Page index starts at 0.
 */
- (CGPoint)originForPage:(NSInteger)newPage;

@end
