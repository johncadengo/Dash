//
//  PlaceViewCell.m
//  Dash
//
//  Created by John Cadengo on 11/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceHeaderViewCell.h"
#import "Place.h"
#import "Place+Helper.h"
#import "UIImage+ProportionalFill.h"
#import "JCLocationManagerSingleton.h"
#import "PlaceLocation.h"
#import "PopLocation.h"
#import "Location+Helper.h"
#import "Constants.h"

@implementation PlaceHeaderViewCell

@synthesize cellType = _cellType;
@synthesize name = _name;
@synthesize categories = _categories;
@synthesize distancePrice = _distancePrice;
@synthesize image = _image;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize imageGalleryViewController = _imageGalleryViewController;
@synthesize themeColor = _themeColor;
@synthesize numRatings = _numRatings;
@synthesize stars = _stars;

#pragma mark - Some UI Constants

static CGFloat kWindowWidth = 320.0f;
static CGFloat kPadding = 7.5f;
static CGFloat kPicWidth = 70.0f;
static CGFloat kMinHeight = 70.0f;
static CGFloat kStarsHeight = 14.5f;
static CGFloat kStarsWidth = 76.0f;

static UILineBreakMode kNameLineBreak = UILineBreakModeTailTruncation;
static UILineBreakMode kBlurbLineBreak = UILineBreakModeWordWrap;

#pragma mark - Class methods for determining the size of UI elements

+ (CGFloat)heightForPlace:(Place *)place withCellType:(PlaceViewCellType)cellType
{
    CGSize nameSize = [self adjustedSizeForName:place.name];
    CGSize categoriesSize = [self sizeForCategories:@"hey hey"];
    CGSize distancePriceSize = [self sizeForDistancePrice:@"0.2 mi $$"];
    
    CGFloat height =  nameSize.height + categoriesSize.height + [self categoriesLeading] + (2 * distancePriceSize.height) + (2 * [self distancePriceLeading]) + kPadding;
    
    return height;
}

+ (UIFont *)nameFont
{
    return [UIFont fontWithName:kPlutoBold size:27.5f];
}

+ (UIFont *)categoriesFont
{
    return [UIFont fontWithName:kPlutoRegular size:14.0f];
}

+ (UIFont *)distancePriceFont
{
    return [UIFont fontWithName:kPlutoRegular size:14.0f];
}

+ (CGSize)sizeForCategories:(NSString *)categories
{
    CGFloat maxWidth = kWindowWidth - kPicWidth - (3 * kPadding);
	CGSize textSize = [categories sizeWithFont:[self categoriesFont] 
                                      forWidth:maxWidth 
                                 lineBreakMode:kBlurbLineBreak];
    
    return textSize;
}

+ (CGSize)sizeForDistancePrice:(NSString *)distancePrice
{
    CGFloat maxWidth = kWindowWidth - kPicWidth - (3 * kPadding);
	CGSize textSize = [distancePrice sizeWithFont:[self distancePriceFont] 
                                         forWidth:maxWidth 
                                    lineBreakMode:kBlurbLineBreak];
    
    return textSize;   
}
+ (NSInteger)numberOfLinesForName:(NSString *)name
{
    // For now, just compare it to the M and the y. Tallest letter, and lowest letter
    CGSize oneLineSize = [[self class] sizeForName:@"My"];
    CGFloat oneLineHeight = oneLineSize.height;
    CGSize nameSize = [self sizeForName:name];
    
    return (nameSize.height > oneLineHeight) ? 2 : 1;
}

+ (CGFloat)nameLeading:(NSString *)name
{
    return ([self numberOfLinesForName:name] == 1) ? -0.0f : -8.0f;
}

+ (CGFloat)categoriesLeading
{
    return -4.0f;
}

+ (CGFloat)distancePriceLeading
{
    return -4.0f;
}

+ (CGSize)sizeForName:(NSString *)name
{
    CGFloat maxWidth = kWindowWidth - kPicWidth - (3 * kPadding);
    CGFloat maxHeight = 2 * self.nameFont.lineHeight;
    CGSize maxSize = CGSizeMake(maxWidth, maxHeight);
	CGSize textSize = [name sizeWithFont:self.nameFont 
                       constrainedToSize:maxSize 
                           lineBreakMode:kNameLineBreak];
    return textSize;
}

+ (CGSize)adjustedSizeForName:(NSString *)name
{
    CGSize originalSize = [self sizeForName:name];
    CGSize adjustedSize = CGSizeMake(originalSize.width, originalSize.height + [[self class] nameLeading: name]);
    return ([self numberOfLinesForName:name] == 1) ? originalSize : adjustedSize;
}

#pragma mark - Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier cellType:PlaceViewCellTypeHeader];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(PlaceViewCellType)cellType
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setCellType:cellType];
    }
    
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setCellType:(PlaceViewCellType)cellType
{
    _cellType = cellType;
    
    switch (_cellType) {
        case PlaceViewCellTypeHeader:
            // Cannot be selected
            [self setSelectionStyle:UITableViewCellSelectionStyleNone];        
            break;
        case PlaceViewCellTypeSquare:
            
            break;
        default:
            NSAssert(NO, @"Trying to set PlaceViewCellType to one that doesn't exist %d", _cellType);
            break;
    }
    
}

#pragma mark - Theme Color
- (void)setThemeColor:(PlaceThemeColor) newColor
{
    // And finally save the new theme color
    _themeColor = newColor;
}

- (NSNumber *)calculateDistanceFromPlace:(Place *)place
{
    // Find out where we are
    CLLocationManager *manager = [JCLocationManagerSingleton sharedInstance];
    CLLocation *loc = [manager location];
    
    PopLocation *location = [NSEntityDescription insertNewObjectForEntityForName:@"PopLocation" inManagedObjectContext:self.managedObjectContext];
    
    [location setWithCLLocation:loc];
    
    return [place.location greatCircleDistanceFrom:location];
    
}

- (void)setWithPlace:(Place *)place context:(NSManagedObjectContext *)context;
{
    // Set our context
    self.managedObjectContext = context;
    
    //PlacePhoto *photo = [[place photos] anyObject];
    //NSString *path = [photo localpath];
    //CGSize size = CGSizeMake(kPicWidth, kPicWidth);
    
    self.name = [place name];
    
    double distance = [[self calculateDistanceFromPlace:place] doubleValue];
    
    NSMutableString *categoryInfo = [[NSMutableString alloc] initWithString:[place categoriesDescriptionLong]];
    
    self.categories = categoryInfo;
    
    // 50+ miles
    if (distance >= kDistanceCutoff) {
        self.distancePrice = [NSString stringWithFormat:@"%@   %@ mi", place.price, kDistanceCutOffString];   
    }
    else {
        self.distancePrice = [NSString stringWithFormat:@"%@   %.1f mi", place.price, distance];    
    }
    
    self.image = [place categoryIconForThemeColor:self.themeColor];
    
    self.stars = [UIImage imageNamed:[place filenameForStarsColor:kStarsColorGrey]];
    
    self.numRatings = [NSString stringWithFormat:@"%@ reviews", [place numRatingsDescription]];
    
    [self setNeedsDisplay];
}

#pragma mark - Draw

- (void)customLeadingDrawing:(NSString *)text withSize:(CGSize)nameSize leading:(CGFloat)leading
{
    // So we can restore the context after we're done playing with clipping
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    // Set the color
    UIColor *textColor = UIColorFromRGB(kPlaceOrangeTextColor);
    [textColor set];
    
    if ([[self class] numberOfLinesForName:self.name] > 1) {
        // If our name is 2 lines tall, clip the top half
        UIRectClip(CGRectMake(kPadding, kPadding + (nameSize.height / 2.0f) + leading, 
                              nameSize.width, nameSize.height / 2.0f));
        
        // And draw it
        [self.name drawInRect:CGRectMake(kPadding, kPadding + leading,
                                         nameSize.width, nameSize.height)
                     withFont:[[self class] nameFont]
                lineBreakMode:kNameLineBreak];
        
        // Then clip the bottom half
        CGContextRestoreGState(context);
        CGContextSaveGState(context);
        UIRectClip(CGRectMake(kPadding, kPadding, 
                              nameSize.width, nameSize.height / 2.0f));
        
        // And draw it
        [textColor set];
        [self.name drawInRect:CGRectMake(kPadding, kPadding,
                                         nameSize.width, nameSize.height)
                     withFont:[[self class] nameFont]
                lineBreakMode:kNameLineBreak];
    }
    else {
        // Otherwise, it is only 1 line tall, so we just draw it normally
        [self.name drawInRect:CGRectMake(kPadding, kPadding,
                                         nameSize.width, nameSize.height)
                     withFont:[[self class] nameFont]
                lineBreakMode:kNameLineBreak];
    }
    
    // After we're all done, let's reset the context
    CGContextRestoreGState(context);
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // Draw the name
    CGSize adjustedNameSize = [[self class] adjustedSizeForName:self.name];
	[self customLeadingDrawing:self.name 
                      withSize:[[self class] sizeForName:self.name]
                       leading:[[self class] nameLeading:self.name]];
    
    // Draw the categories and price, distance
    UIColor *textColor = UIColorFromRGB(kPlaceCategoriesTextColor);
    [textColor set];
    
    [self.stars drawAtPoint:CGPointMake(kPadding, adjustedNameSize.height)];
    
    CGSize starsRatingsSize = [[self class] sizeForDistancePrice:self.distancePrice];
    [self.numRatings drawAtPoint:CGPointMake(kPadding + kStarsWidth + kPadding, adjustedNameSize.height) 
                        withFont:[self.class distancePriceFont]];
    
    CGSize categoriesSize = [[self class] sizeForCategories:self.categories];
    [self.categories drawInRect:CGRectMake(kPadding, 
                                           adjustedNameSize.height + starsRatingsSize.height + [self.class distancePriceLeading], 
                                           categoriesSize.width, categoriesSize.height) 
                       withFont:[[self class] categoriesFont] 
                  lineBreakMode:kBlurbLineBreak];
    
    CGSize distancePriceSize = [[self class] sizeForDistancePrice:self.distancePrice];
    [self.distancePrice drawInRect:CGRectMake(kPadding, 
                                              adjustedNameSize.height + starsRatingsSize.height + [self.class distancePriceLeading] 
                                              + categoriesSize.height + [[self class] categoriesLeading], 
                                              distancePriceSize.width, distancePriceSize.height) 
                          withFont:[[self class] distancePriceFont] 
                     lineBreakMode:kBlurbLineBreak];
    
    // Now draw the image
    CGPoint point = CGPointMake(kWindowWidth - 10.0f - kPicWidth, 0.0f);
    [self.image drawAtPoint:point];
}

@end
