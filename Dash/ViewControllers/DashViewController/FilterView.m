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

- (void)drawHorizontalLineStartingAt:(CGPoint)origin withLength:(CGFloat)length;
{
    // Get the context
    CGContextRef context = UIGraphicsGetCurrentContext();	
    
    // Set the stroke color and width of the pen
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(kFilterLinesColor).CGColor);
    CGContextSetLineWidth(context, 1.0f);
    
	// Set the starting and ending points
	CGContextMoveToPoint(context, origin.x, origin.y);
    CGContextAddLineToPoint(context, origin.x + length, origin.y);
    
	// Draw the line
    CGContextStrokePath(context);    
}

- (void)drawHeader:(NSString *)text at:(CGPoint)origin
{
    [[UIColor whiteColor] set];
    UIFont *font = [UIFont fontWithName:kHelveticaNeueBold size:14.0f];
    [text drawAtPoint:origin withFont:font];
}

- (void)drawFourImages:(NSArray *)arr at:(CGPoint)origin
{
    CGFloat totalWidth = self.frame.size.width; // Should be.. 320.0f
    CGFloat width = 25.0f;
    
    for (UIImage *image in arr) {
        [image drawAtPoint:origin];
    }
    
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // Lets draw the two separators
    [self drawHorizontalLineStartingAt:CGPointMake(25.0f, 100.0f) withLength:270.0f];
    [self drawHorizontalLineStartingAt:CGPointMake(25.0f, 160.0f) withLength:270.0f];
    
    // Draw the headers
    [self drawHeader:[NSString stringWithFormat:@"Type"] at:CGPointMake(10.0f, 0.0f)];
    [self drawHeader:[NSString stringWithFormat:@"Distance"] at:CGPointMake(10.0f, 175.0f)];

    // Draw the type images
    NSArray *typeImages = [NSArray arrayWithObjects:
                           [UIImage imageNamed:@"BurgerShakeIcon.png"],
                           [UIImage imageNamed:@"ForkKnifeIcon.png"],
                           [UIImage imageNamed:@"WineIcon.png"],
                           [UIImage imageNamed:@"CupcakeIcon.png"],nil];
    [self drawFourImages:typeImages at:CGPointMake(10.0f, 20.0f)];
    
    
    /*
    NSArray *distanceImages = [NSArray arrayWithObjects:
                               [UIImage imageNamed:@""],
                               [UIImage imageNamed:@""],
                               [UIImage imageNamed:@""],
                               [UIImage imageNamed:@""],nil];
     */


}


@end
