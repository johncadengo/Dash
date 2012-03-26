//
//  FilterView.h
//  Dash
//
//  Created by John Cadengo on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    DistanceFilterAuto = 0,
    DistanceFilter5Blocks = 1,
    DistanceFilter1Mile = 2,
    DistanceFilter5Miles = 3,
    NumDistanceFilterTypes = 4
} DistanceFilter;

@interface FilterView : UIView

// State
@property (nonatomic, strong) NSMutableArray *typesChecked;
@property (nonatomic, strong) NSMutableArray *pricesChecked;
@property (nonatomic) DistanceFilter *currentDistanceFilter;

// Frames
@property (nonatomic, strong) NSMutableArray *typesFrames;
@property (nonatomic, strong) NSMutableArray *pricesFrames;
@property (nonatomic, strong) NSMutableArray *distanceFrames;

- (void)drawHorizontalLineStartingAt:(CGPoint)origin withLength:(CGFloat)length;
- (void)drawHeader:(NSString *)text at:(CGPoint)origin;

/** Assumes that the four images fit in the frame and all have the same dimensions.
 */
- (void)drawFourImages:(NSArray *)arr at:(CGFloat)y;

@end
