//
//  FilterView.m
//  Dash
//
//  Created by John Cadengo on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FilterView.h"

@implementation FilterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    NSLog(@"Filter view draw rect");
    
    [super drawRect:rect];
    
    // Custom Drawing
    CGContextRef context = UIGraphicsGetCurrentContext();	
    
    // Set the stroke (pen) color	
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);	
    
    // Set the width of the pen mark	
    CGContextSetLineWidth(context, 5.0);
    
	// Start at this point
	CGContextMoveToPoint(context, 10.0, 30.0);
    
	// Move "pen" around the screen
    CGContextAddLineToPoint(context, 310.0, 30.0);	
    CGContextAddLineToPoint(context, 310.0, 90.0);	
    CGContextAddLineToPoint(context, 10.0, 90.0);
    
	//Draw it
    CGContextStrokePath(context);
    
}


@end
