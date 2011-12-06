//
//  PlaceSquareViewCell.m
//  Dash
//
//  Created by John Cadengo on 12/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceSquareViewCell.h"

@implementation PlaceSquareViewCell

@synthesize name = _name;
@synthesize info = _info;
@synthesize blurb = _blurb;
@synthesize badges = _badges;
@synthesize icon = _icon;

#pragma mark - UI Constants

static CGFloat kWidth = 160.0f;
static CGFloat kHeight = 160.0f;

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Set

- (void)setWithPlace:(Place *)place
{
    // Set all our instance variables
    
    
    // Draw self
    [self setNeedsDisplay];
}

#pragma mark - Draw

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
