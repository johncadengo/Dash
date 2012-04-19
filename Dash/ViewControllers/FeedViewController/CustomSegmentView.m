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
@synthesize leftHalf = _leftHalf;
@synthesize tap = _tap;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        // By default, left is selected
        self.leftSelected = YES;
        self.leftHalf = CGRectMake(0.0f, 0.0f, frame.size.width / 2.0f, frame.size.height);
        
        // Make sure we handle touches
        self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.tap setDelegate:self];
        [self addGestureRecognizer:self.tap];
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

#pragma mark - Handle tap

- (void)handleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    // Find out where we tapped
    CGPoint tapPoint = [gestureRecognizer locationInView:self];

    if (CGRectContainsPoint(self.leftHalf, tapPoint)) {
        NSLog(@"Left");
    }
    else {
        NSLog(@"Right");
    }
}
#pragma mark - Draw

- (void)drawRect:(CGRect)rect
{
    [self.backgroundImage drawAtPoint:CGPointZero];
}

@end
