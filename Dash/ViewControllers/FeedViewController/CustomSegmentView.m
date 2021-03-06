//
//  CustomSegment.m
//  Dash
//
//  Created by John Cadengo on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomSegmentView.h"
#import "DashAPI.h"
#import "Constants.h"

@implementation CustomSegmentView

@synthesize backgroundImage = _backgroundImage;
@synthesize leftSelected = _leftSelected;
@synthesize leftHalf = _leftHalf;
@synthesize tap = _tap;
@synthesize alertView = _alertView;

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

    // Set selected based on that
    if (CGRectContainsPoint(self.leftHalf, tapPoint)) {
        [self setLeftSelected:YES];
    }
    else {
        if ([DashAPI loggedIn]) {
            [self setLeftSelected:NO];     
        }
        else {  
            if (self.alertView == nil) {
                self.alertView = [[UIAlertView alloc] initWithTitle:kLoginAlertTitle message:kLoginAlertMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            }
            [self.alertView show];
        }
    }
}
#pragma mark - Draw

- (void)drawRect:(CGRect)rect
{
    [self.backgroundImage drawAtPoint:CGPointZero];
}

@end
