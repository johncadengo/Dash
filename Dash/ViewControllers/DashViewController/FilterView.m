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

@synthesize typesChecked = _typesChecked;
@synthesize pricesChecked = _pricesChecked;
@synthesize currentDistanceFilter = _currentDistanceFilter;
@synthesize typesFrames = _typesFrames;
@synthesize pricesFrames = _pricesFrames;
@synthesize distancesFrames = _distancesFrames;
@synthesize typesImages = _typesImages;
@synthesize pricesImages = _pricesImages;
@synthesize distancesImages = _distancesImages;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // By default, none are checked
        self.typesChecked = [[NSMutableArray alloc] initWithObjects:
                             [NSNumber numberWithBool:NO], 
                             [NSNumber numberWithBool:NO],
                             [NSNumber numberWithBool:NO],
                             [NSNumber numberWithBool:NO],nil];
        
        // By default, the first three are checked, and the last is unchecked
        self.pricesChecked = [[NSMutableArray alloc] initWithObjects:
                              [NSNumber numberWithBool:YES],
                              [NSNumber numberWithBool:YES],
                              [NSNumber numberWithBool:YES],
                              [NSNumber numberWithBool:NO],nil];
        
        // By default, we use auto distance filter
        self.currentDistanceFilter = DistanceFilterAuto;
        
        // Frames
        self.typesFrames = [[NSMutableArray alloc] initWithObjects:
                            [NSValue valueWithCGRect:CGRectZero],
                            [NSValue valueWithCGRect:CGRectZero],
                            [NSValue valueWithCGRect:CGRectZero],
                            [NSValue valueWithCGRect:CGRectZero],nil];
        
        self.pricesFrames = [[NSMutableArray alloc] initWithObjects:
                             [NSValue valueWithCGRect:CGRectZero],
                             [NSValue valueWithCGRect:CGRectZero],
                             [NSValue valueWithCGRect:CGRectZero],
                             [NSValue valueWithCGRect:CGRectZero],nil];
        
        self.distancesFrames = [[NSMutableArray alloc] initWithObjects:
                                [NSValue valueWithCGRect:CGRectZero],
                                [NSValue valueWithCGRect:CGRectZero],
                                [NSValue valueWithCGRect:CGRectZero],
                                [NSValue valueWithCGRect:CGRectZero],nil];
        
        // Images
        self.typesImages = [NSArray arrayWithObjects:
                            [UIImage imageNamed:@"BurgerShakeIcon.png"],
                            [UIImage imageNamed:@"ForkKnifeIcon.png"],
                            [UIImage imageNamed:@"WineIcon.png"],
                            [UIImage imageNamed:@"CupcakeIcon.png"],nil];
        
        self.pricesImages = [NSArray arrayWithObjects:
                             [UIImage imageNamed:@"1Dollar.png"],
                             [UIImage imageNamed:@"2Dollar.png"],
                             [UIImage imageNamed:@"3Dollar.png"],
                             [UIImage imageNamed:@"4Dollar.png"],nil];
        
        self.distancesImages = [NSArray arrayWithObjects:
                                [UIImage imageNamed:@"RadarIcon.png"],
                                [UIImage imageNamed:@"WalkingManIcon.png"],
                                [UIImage imageNamed:@"BikeIcon.png"],
                                [UIImage imageNamed:@"CarIcon.png"],nil];
        
    }
    return self;
}

#pragma mark -

- (BOOL)indexSelected:(NSInteger)i ForArray:(NSArray *)arr
{
    if (arr == self.typesImages) {
        return [self typeSelectedAtIndex:i];
    }
    else if (arr == self.pricesImages) {
        return [self priceSelectedAtIndex:i];
    }
    else if (arr == self.distancesImages) {
        return [self distanceSelectedAtIndex:i];
    }
    
    return NO;
}

- (BOOL)typeSelectedAtIndex:(NSInteger)i
{
    return [[self.typesChecked objectAtIndex:i] boolValue];
}

- (BOOL)priceSelectedAtIndex:(NSInteger)i
{
    return [[self.pricesChecked objectAtIndex:i] boolValue];
}

- (BOOL)distanceSelectedAtIndex:(NSInteger)i
{
    return (self.currentDistanceFilter == i) ? YES : NO;
}

#pragma mark -

- (void)drawHorizontalLineStartingAt:(CGPoint)origin withLength:(CGFloat)length
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

- (void)drawFourImages:(NSArray *)arr withFrames:(NSMutableArray *)frames at:(CGFloat)y
{
    CGFloat totalWidth = 320.0f;
    UIImage *image = [arr objectAtIndex:0];
    CGFloat width = image.size.width;
    NSInteger numImages = 4;
    CGRect frame;
    
    for (NSInteger i = 0; i < numImages; ++i) {
        // Get image and calculate its origin
        UIImage *image = [arr objectAtIndex:i];
        CGFloat margins = ((totalWidth - (width * numImages)) / (numImages + 1)); // 4 images means 5 margins
        CGFloat x = (i * width) + ((i + 1) * margins);
        
        // Based on its size and origin, calculate its frame and save it
        frame = CGRectMake(x, y, image.size.width, image.size.height);
        [frames replaceObjectAtIndex:i withObject:[NSValue valueWithCGRect:frame]];
        
        // If it is checked, draw it a different way than if it is unchecked.
        if ([self indexSelected:i ForArray:arr]) {
            [image drawAtPoint:CGPointMake(x, y) blendMode:kCGBlendModeOverlay alpha:1.0f];
        }
        else {
            [image drawAtPoint:CGPointMake(x, y) blendMode:kCGBlendModeOverlay alpha:0.25f];
        }
    }
     
}

- (void)drawTypesAt:(CGFloat)y
{
    [self drawFourImages:self.typesImages withFrames:self.typesFrames at:y];
}

- (void)drawPricesAt:(CGFloat)y
{
    [self drawFourImages:self.pricesImages withFrames:self.pricesFrames at:y];
}

- (void)drawDistancesAt:(CGFloat)y
{
    [self drawFourImages:self.distancesImages withFrames:self.distancesFrames at:y];
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

    // Draw the images
    [self drawTypesAt:20.0f];
    [self drawPricesAt:110.0f];
    [self drawDistancesAt:195.0f];
    



}


@end
