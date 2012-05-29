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
#import "JCLocationManagerSingleton.h"
#import "PopLocation.h"
#import "PlaceLocation.h"
#import "Location+Helper.h"
#import "Location.h"

@implementation RecommendedPlaceViewCell

@synthesize context = _context;
@synthesize type = _type;
@synthesize name = _name;
@synthesize address = _address;
@synthesize category = _category;
@synthesize distancePrice = _distancePrice;
@synthesize backgroundImage = _backgroundImage;
@synthesize icon = _icon;

#pragma mark - Some UI Constants

static const CGFloat kWidth = 320.0f;
static const CGFloat kLineLength = 284.0f;
static const CGFloat kPadding = 20.0f;

static const CGFloat kTopHeight = 66.5f;
static const CGFloat kMiddleHeight = 63.0f;
static const CGFloat kBottomHeight = 73.0f;
static const CGFloat kOnlyHeight = 71.5f;

static const CGFloat kTopYOffset = 11.5f;
static const CGFloat kYOffset = 8.0f;

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
        case RecommendedPlaceViewCellTypeOnly:
            height = kOnlyHeight;
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
        case RecommendedPlaceViewCellTypeOnly:
            imageName = @"PlacesOnePiece.png";
            break;
        default:
            imageName = @"PlacesMiddle.png";
            break;
    }
    
    self.backgroundImage = [UIImage imageNamed:imageName];
}


- (NSNumber *)calculateDistanceFromPlace:(Place *)place
{
    // Find out where we are
    CLLocationManager *manager = [JCLocationManagerSingleton sharedInstance];
    CLLocation *loc = [manager location];
    
    PopLocation *location = [NSEntityDescription insertNewObjectForEntityForName:@"PopLocation" inManagedObjectContext:self.context];
    
    [location setWithCLLocation:loc];
    
    return [place.location greatCircleDistanceFrom:location];
    
}

- (void)setWithPlace:(Place *)place context:(NSManagedObjectContext *)context;
{
    // Set our context
    self.context = context;

    self.name = place.name;
    self.address = place.address;
    double distance = [[self calculateDistanceFromPlace:place] doubleValue];
    
    NSMutableString *categoryInfo = [[NSMutableString alloc] initWithString:[place categoriesDescriptionLong]];
    self.category= categoryInfo;
    
    // 50+ miles
    if (distance >= kDistanceCutoff) {
        self.distancePrice = [NSString stringWithFormat:@"%@   %@ mi", kDistanceCutOffString, place.price];   
    }
    else {
        self.distancePrice = [NSString stringWithFormat:@"%@   %.1f mi", distance, place.price];    
    }
    
    // Some logic here
    self.icon = [place categoryIconSmall];
    
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
    
    CGFloat offset = (self.type == RecommendedPlaceViewCellTypeFirst || self.type == RecommendedPlaceViewCellTypeOnly) ? kTopYOffset : kYOffset;
    CGFloat height = [[self class] heightForType:self.type];
    
    // Draw the background
    [self.backgroundImage drawAtPoint:CGPointZero];
    
    // Draw the title, the name
    [UIColorFromRGB(kRecommendedPlaceTitleColor) set];
    [self.name drawAtPoint:CGPointMake(kPadding, offset) withFont:[[self class] titleFont]];
    
    // Draw the subtitle, the category and the price and distance
    [UIColorFromRGB(kRecommendedPlaceSubtitleColor) set];
    [self.address drawAtPoint:CGPointMake(kPadding, offset + 14.0f + 5.0f) withFont:[[self class] subtitleFont]];
    [self.distancePrice drawAtPoint:CGPointMake(kPadding, offset + 14.0f + 5.0f + 10.0f + 5.0f) 
                           withFont:[[self class] subtitleFont]];
    
    // Icon
    CGSize iconSize = CGSizeMake(25.0f, 25.0f);
    [self.icon drawAtPoint:CGPointMake(kWidth - kPadding - iconSize.width, offset)];
    [self.category drawInRect:CGRectMake(kPadding + 50.0f, offset + 14.0f + 5.0f + 10.0f + 5.0f, 
                                         kWidth - kPadding - iconSize.width - 50.0f, 16.0f) 
                     withFont:[[self class] subtitleFont] 
                lineBreakMode:UILineBreakModeTailTruncation 
                    alignment:UITextAlignmentRight];
    
    // Draw line at bottom, as long as we aren't the last cell
    if (self.type != RecommendedPlaceViewCellTypeLast && self.type != RecommendedPlaceViewCellTypeOnly) {
        CGPoint origin = CGPointMake((kWidth - kLineLength) / 2.0f, height);
        [self drawHorizontalLineStartingAt:origin withLength:kLineLength];
    }
}

@end
