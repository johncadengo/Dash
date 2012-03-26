//
//  FilterView.h
//  Dash
//
//  Created by John Cadengo on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kFilterTypeQuickEat = 0,
    kFilterTypeSitDown = 1,
    kFilterTypeDrinks = 2,
    kFilterTypeDessert = 3
} FilterType;

@class FilterView;

@interface FilterViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) FilterView *filterView;
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;

- (void)invertTypeCheckedAtIndex:(NSInteger)i;
- (void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer;

@end
