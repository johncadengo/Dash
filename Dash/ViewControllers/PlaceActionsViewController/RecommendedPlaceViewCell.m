//
//  PlaceViewCell.m
//  Dash
//
//  Created by John Cadengo on 11/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RecommendedPlaceViewCell.h"
#import "Place.h"
#import "Place+Helper.h"
#import "PlaceAction.h"
#import "Constants.h"
#import "NSArray+Helpers.h"

@implementation RecommendedPlaceViewCell

@synthesize type = _type;
@synthesize name = _name;
@synthesize category = _category;
@synthesize distancePrice = _distancePrice;
@synthesize backgroundImage = _backgroundImage;
@synthesize icon = _icon;

#pragma mark - Some UI Constants

static CGFloat kWidth = 320.0f;
static CGFloat kLineLength = 284.0f;
static CGFloat kPadding = 15.0f;

static CGFloat kTopHeight = 80.0f;
static CGFloat kMiddleHeight = 64.0f;
static CGFloat kBottomHeight = 72.0f;

#pragma mark - Class methods for determining the size of UI elements
    
+ (CGFloat)heightForType:(RecommendedPlaceViewCellType)type
{
    CGFloat height;
    
    switch (type) {
        case RecommendedPlaceViewCellTypeFirst:
            height = kTopHeight;
            break;
        case RecommendedPlaceViewCellTypeLast:
            height = kBottomHeight;
            break;
        default:
            height = kMiddleHeight;
            break;
    }
    
    return height;
}

+ (UIFont *)titleFont
{
    return [UIFont fontWithName:kHelveticaNeueBold size:14.0f];
}

+ (UIFont *)subtitleFont
{
    return [UIFont systemFontOfSize:10.0f];
}

#pragma mark -


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(RecommendedPlaceViewCellType)type
{
    self = [self initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Now initiate the type
        self.type = type;
    }
    
    return self;
}

- (void)setType:(RecommendedPlaceViewCellType)type
{
    _type = type;
    
    // Adjust the background bubble accordingly
    NSString *imageName;
    switch (_type) {
        case RecommendedPlaceViewCellTypeFirst:
            imageName = @"PlacesTop.png";
            break;
        case RecommendedPlaceViewCellTypeLast:
            imageName = @"PlacesBottom.png";
            break;
        default:
            imageName = @"PlacesMiddle.png";
            break;
    }
    
    self.backgroundImage = [UIImage imageNamed:imageName];
}

- (void)setWithPlace:(Place *)place
{
    // Some logic here
    NSArray *iconChoices = [NSArray arrayWithObjects:
                            @"Burger-Places.png", @"Taco-Places.png", 
                            @"Pizza-Places.png", @"Noodles-Places.png" ,nil];
    NSString *iconName = [NSString stringWithFormat:@"%@", [iconChoices randomObject]];
    self.icon = [UIImage imageNamed:iconName];
    
    // Draw self
    [self setNeedsDisplay];    
}

#pragma mark - Draw


- (void)drawHorizontalLineStartingAt:(CGPoint)origin withLength:(CGFloat)length
{
    // Get the context
    CGContextRef context = UIGraphicsGetCurrentContext();	
    
    // Set the stroke color and width of the pen
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(kHighlightLinesColor).CGColor);
    CGContextSetLineWidth(context, 1.0f);
    
	// Set the starting and ending points
	CGContextMoveToPoint(context, origin.x, origin.y);
    CGContextAddLineToPoint(context, origin.x + length, origin.y);
    
	// Draw the line
    CGContextStrokePath(context);    
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // Draw the background
    [self.backgroundImage drawAtPoint:CGPointZero];
    
    // TODO: Some logic here
    CGSize iconSize = CGSizeMake(50.0f, 50.0f);
    [self.icon drawAtPoint:CGPointMake(kWidth - kPadding - iconSize.width, kPadding)];
    
    // Draw line at bottom, as long as we aren't the last cell
    if (self.type != RecommendedPlaceViewCellTypeLast) {
        CGPoint origin = CGPointMake((kWidth - kLineLength) / 2.0f, [[self class] heightForType:self.type]);
        [self drawHorizontalLineStartingAt:origin withLength:kLineLength];
    }
}

@end
