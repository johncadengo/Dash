//
//  BadgeSquareView.m
//  Dash
//
//  Created by John Cadengo on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BadgeSquareView.h"
#import "Badge.h"

@implementation BadgeSquareView

static CGFloat kWidth = 75.0f;
static CGFloat kHeight = 70.0f;

@synthesize icon = _icon;
@synthesize text = _text;

+ (CGSize)size
{
    return CGSizeMake(kWidth, kHeight);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

- (void)setWithBadge:(Badge *)badge
{
    self.text = [NSString stringWithFormat:@"%@", badge.name];
    
    [self setNeedsDisplay];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // Draw the text
    [self.text drawAtPoint:CGPointZero withFont:[UIFont systemFontOfSize:10.0f]];
}


@end
