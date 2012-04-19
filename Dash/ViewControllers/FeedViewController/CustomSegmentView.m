//
//  CustomSegment.m
//  Dash
//
//  Created by John Cadengo on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomSegmentView.h"

@implementation CustomSegmentView

@synthesize backgroundImage = _backgroundImage;
@synthesize leftSelected = _leftSelected;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        // By default, left is selected
        self.leftSelected = YES;
    }
    return self;
}

#pragma mark - Override setter

- (void)setLeftSelected:(BOOL)leftSelected
{
    // Whatever is selected, gotta make sure we draw the right image
    _leftSelected = leftSelected;
    
    self.backgroundImage = [UIImage imageNamed:(_leftSelected) ? @"TopBarNearbySelected.png":@"TopBarFriendsSelected.png"];
    
    [self setNeedsDisplay];
}

#pragma mark - Draw

- (void)drawRect:(CGRect)rect
{
    [self.backgroundImage drawAtPoint:CGPointZero];
}

@end
