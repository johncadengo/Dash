//
//  FilterView.h
//  Dash
//
//  Created by John Cadengo on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterView.h"

typedef enum {
    kFilterTypeQuickEat = 0,
    kFilterTypeSitDown = 1,
    kFilterTypeDrinks = 2,
    kFilterTypeDessert = 3
} FilterType;

@class FilterView;

@interface FilterViewController : UIViewController <UIGestureRecognizerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) FilterView *filterView;
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (nonatomic) CGRect locationButtonFrame;
@property (nonatomic, strong) UIButton *locationButton;

@property (nonatomic, strong) UIActionSheet *changeLocationSheet;

- (void)invertTypeCheckedAtIndex:(NSInteger)i;
- (void)invertPriceCheckedAtIndex:(NSInteger)i;
- (void)setDistanceChecked:(DistanceFilter)i;

/** Sends an action sheet up to prompt for a change in location
 */
- (void)promptForLocation:(id)sender;

// Checks if any frames contain the point. Returns index >= 0 if found. -1 if not.
- (NSInteger)indexOfFrames:(NSArray *)arr containPoint:(CGPoint)point;

// BOOLs return whether or not to redraw filter view
- (BOOL)handleTypesTapped:(CGPoint)origin;
- (BOOL)handlePricesTapped:(CGPoint)origin;
- (BOOL)handleDistanceTapped:(CGPoint)origin;
- (void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer;

@end
