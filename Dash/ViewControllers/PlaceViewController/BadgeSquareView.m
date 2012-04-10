//
//  BadgeSquareView.m
//  Dash
//
//  Created by John Cadengo on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BadgeSquareView.h"
#import "Badge.h"
#import "Badge+Helper.h"

@implementation BadgeSquareView

static CGFloat kWidth = 75.0f;
static CGFloat kHeight = 71.0f;
static CGFloat kIconWidth = 40.0f;

@synthesize icon = _icon;
@synthesize label = _label;

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
        
        self.label = [[UILabel alloc] initWithFrame: CGRectMake(0.0f, kIconWidth + 2.5f, 
                                kWidth, kHeight - (kIconWidth + 2.5f))];
        [self.label setFont:[UIFont systemFontOfSize:10.0f]];
        [self.label setNumberOfLines:2];
        [self.label setLineBreakMode:UILineBreakModeWordWrap];
        [self.label setTextAlignment:UITextAlignmentCenter];
        [self.label setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.label];
    }
    return self;
}

- (void)setWithBadge:(Badge *)badge
{
    self.label.text = [[NSString stringWithFormat:@"Popular On %@", badge.name] capitalizedString];
    self.icon = badge.icon;
    
    [self setNeedsDisplay];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // Draw the icon
    [self.icon drawInRect:CGRectMake((kWidth - kIconWidth) / 2.0f, 2.5f, kIconWidth, kIconWidth)];
}


@end
