//
//  CustomSegment.h
//  Dash
//
//  Created by John Cadengo on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSegmentView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, getter=isLeftSelected) BOOL leftSelected;
@property (nonatomic) CGRect leftHalf;
@property (nonatomic, strong) UITapGestureRecognizer *tap;

- (void)handleTap:(UITapGestureRecognizer *)gestureRecognizer;

@end
