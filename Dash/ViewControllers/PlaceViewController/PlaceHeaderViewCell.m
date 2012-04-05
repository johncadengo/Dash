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

#pragma mark - Some UI Constants

static CGFloat kWindowWidth = 320.0f;
static CGFloat kPadding = 7.5f;
static CGFloat kPicWidth = 70.0f;
static CGFloat kMinHeight = 110.0f;

static CGFloat kMaxBlurbHeight = 1000.0f;

static UILineBreakMode kNameLineBreak = UILineBreakModeTailTruncation;
static UILineBreakMode kBlurbLineBreak = UILineBreakModeWordWrap;

#pragma mark - Class methods for determining the size of UI elements

+ (CGFloat)heightForPlace:(Place *)place withCellType:(PlaceViewCellType)cellType
{
    CGSize nameSize = [self adjustedSizeForName:@"hi"];
    CGSize categoriesSize = [self sizeForCategories:@"hey hey"];
    CGSize distancePriceSize = [self sizeForDistancePrice:@"0.2 mi $$"];
    
    CGFloat height = kPadding + nameSize.height + kPadding + categoriesSize.height + kPadding + distancePriceSize.height + kPadding;
    
    return MAX(height, kMinHeight);
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
    self.distancePrice = [NSString stringWithFormat:@"%.1f mi   %@", distance, place.price];
    //self.image = [[UIImage imageNamed:path] imageCroppedToFitSize:size];
    
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
    UIColor *textColor = [UIColor blackColor];
    [textColor set];
    CGSize categoriesSize = [[self class] sizeForCategories:self.categories];
    [self.categories drawInRect:CGRectMake(kPadding, adjustedNameSize.height, 
                                           categoriesSize.width, categoriesSize.height) 
                       withFont:[[self class] categoriesFont] 
                  lineBreakMode:kBlurbLineBreak];
    
    textColor = [UIColor blackColor];
    [textColor set];
    CGSize distancePriceSize = [[self class] sizeForDistancePrice:self.distancePrice];
    [self.distancePrice drawInRect:CGRectMake(kPadding, 
                                              adjustedNameSize.height + categoriesSize.height + [[self class] categoriesLeading], 
                                              distancePriceSize.width, distancePriceSize.height) 
                          withFont:[[self class] distancePriceFont] 
                     lineBreakMode:kBlurbLineBreak];
    
    // Now draw the image
    CGPoint point = CGPointMake(kPadding, kPadding);
    [self.image drawAtPoint:point];
}

@end
