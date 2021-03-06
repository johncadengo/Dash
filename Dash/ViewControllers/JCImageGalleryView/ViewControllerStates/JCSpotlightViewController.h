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

/** Calculates the origin for the page. Page index starts at 0.
 */
+ (CGPoint)originForOffset:(NSInteger)newOffset;

/** Calculate what page we are based on the origin. Page index starts at 0.
 */
+ (NSInteger)offsetForOrigin:(CGPoint)origin;

+ (CGPoint)originForRow:(NSInteger)row column:(NSInteger)column;
+ (CGPoint)contentViewOffsetForRow:(NSInteger)row column:(NSInteger)column;

+ (CGSize)contentSizeForNumImages:(NSInteger)numImages;

+ (CGSize)contentSizeInRowsForNumImages:(NSInteger)numImages;

/** Called in the spotlight view to turn the toolbar visible and hidden.
 */
- (void)toggleToolbar;

/** Called when the done button is pushed. Will return us back to the pinhole view.
 */
- (void)handleDone:(id)sender;

/** Called when the see all button is pushed. Will transition to the gallery view.
 */
- (void)handleSeeAll:(id)sender;

@end
