//
//  FilterView.m
//  Dash
//
//  Created by John Cadengo on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FilterView.h"
#import "Constants.h"

@implementation FilterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawLineStartingAt:(CGPoint)origin withLength:(CGFloat)length;
{
    // Custom Drawing
    CGContextRef context = UIGraphicsGetCurrentContext();	
    
    // Set the stroke color
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(kFilterLinesColor).CGColor);	
    
    // Set the width of the pen mark	
    CGContextSetLineWidth(context, 1.0f);
    
	// Start at this point
	CGContextMoveToPoint(context, origin.x, origin.y);
    
	// Move "pen" around the screen
    CGContextAddLineToPoint(context, origin.x + length, origin.y);
    
	//Draw it
    CGContextStrokePath(context);    
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // Lets draw the two separators
    [self drawLineStartingAt:CGPointMake(25.0f, 100.0f) withLength:270.0f];
    [self drawLineStartingAt:CGPointMake(25.0f, 220.0f) withLength:270.0f];
    
}


@end
