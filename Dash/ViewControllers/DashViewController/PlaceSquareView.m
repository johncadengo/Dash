//
//  PlaceSquareViewCell.m
//  Dash
//
//  Created by John Cadengo on 12/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceSquareView.h"
#import "Place.h"
#import "Place+Helper.h"
#import "Category.h"
#import "Constants.h"
#import "JCLocationManagerSingleton.h"
#import "NSArray+Helpers.h"

@implementation PlaceSquareView

@synthesize name = _name;
@synthesize categories = _categories;
@synthesize distancePrice = _distancePrice;
@synthesize blurb = _blurb;
@synthesize badges = _badges;
@synthesize icon = _icon;
@synthesize backgroundImage = _backgroundImage;
@synthesize managedObjectContext = _managedObjectContext;

#pragma mark - UI Constants

static CGFloat kWidth = 160.0f;
static CGFloat kHeight = 160.0f;
static CGFloat kPadding = 5.0f;
static CGFloat kHalfPadding = 1.0f;
static CGFloat kMaxBlurbHeight = 1000.0f;

static UILineBreakMode kNameLineBreak = UILineBreakModeTailTruncation;
static UILineBreakMode kInfoLinebreak = UILineBreakModeTailTruncation;
static UILineBreakMode kBlurbLineBreak = UILineBreakModeWordWrap;

#pragma mark - Class methods for figuring out layout

+ (CGSize)size
{
    return CGSizeMake(kWidth, kHeight);
}

+ (UIFont *)nameFont
{
    return [UIFont fontWithName:kPlutoBold size:20.0f];
}

+ (UIFont *)categoriesFont
{
    return [UIFont fontWithName:kPlutoBold size:12.0f];    
}

+ (UIFont *)distancePriceFont
{
    return [UIFont fontWithName:kPlutoBold size:12.0f];
}

+ (UIFont *)blurbFont
{
    return [UIFont systemFontOfSize:10];
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
    CGFloat maxWidth = kWidth - (2 * kPadding);
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

+ (CGSize)sizeForCategories:(NSString *)categories
{
    CGFloat maxWidth = kWidth - (2 * kPadding);
	CGSize textSize = [categories sizeWithFont:[self categoriesFont] 
                                      forWidth:maxWidth 
                                 lineBreakMode:kInfoLinebreak];
    
    return textSize;
}

+ (CGSize)sizeForDistancePrice:(NSString *)distancePrice
{
    CGFloat maxWidth = kWidth - (2 * kPadding);
	CGSize textSize = [distancePrice sizeWithFont:[self distancePriceFont] 
                                         forWidth:maxWidth 
                                    lineBreakMode:kInfoLinebreak];
    
    return textSize;   
}

+ (CGSize)sizeForBlurb:(NSString *)blurb
{
    // TODO: We need to figure out the max size for the blurb
    // especially in relation to its font size.
    CGFloat maxWidth = kWidth - (2 * kPadding);
    CGSize maxSize = CGSizeMake(maxWidth, kMaxBlurbHeight);
	CGSize textSize = [blurb sizeWithFont:[self blurbFont] 
                        constrainedToSize:maxSize
                            lineBreakMode:kBlurbLineBreak];
    
    return textSize;
}

+ (CGColorRef)black {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    static CGColorRef black = NULL;
    if(black == NULL) {
        CGFloat values[4] = {0.0, 0.0, 0.0, 1.0};
        black = CGColorCreate(colorSpace, values);
    }
    return black;
}


#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame backgroundImage:(UIImage *)backgroundImage
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor blackColor]];
        self.backgroundImage = backgroundImage;
    }
    return self;
}

#pragma mark - Set

- (void)setWithPlace:(Place *)place context:(NSManagedObjectContext *)context
{
    // Set our context
    self.managedObjectContext = context;
    
    // Set all our instance variables
    self.name = [place name];
    
    NSMutableString *categoryInfo = [[NSMutableString alloc] initWithString:[place categoriesDescriptionShort]];
    //[categoryInfo appendFormat:@" / %@", place.price];
    
    double distance = [[JCLocationManagerSingleton calculateDistanceFromPlace:place withManagedObjectContext:self.managedObjectContext] doubleValue];
    
    self.categories = categoryInfo;
    self.distancePrice = [NSString stringWithFormat:@"%.1f mi   %@", distance, place.price];
    self.blurb = [NSString stringWithFormat:@""];
    
    // Some logic here
    NSArray *iconChoices = [NSArray arrayWithObjects:
                            @"DashBurgerIcon.png", @"DashTacoIcon.png", 
                            @"DashPizzaIcon.png", @"DashNoodlesIcon.png" ,nil];
    NSString *iconName = [NSString stringWithFormat:@"%@", [iconChoices randomObject]];
    self.icon = [UIImage imageNamed:iconName];
    
    // Draw self
    [self setNeedsDisplay];
}

#pragma mark - Draw

- (void)customLeadingDrawing:(NSString *)text withSize:(CGSize)nameSize leading:(CGFloat)leading
{
    // So we can restore the context after we're done playing with clipping
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    // Set the color
    UIColor *textColor = [UIColor whiteColor];
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
    
    // Custom drawing
    [self.backgroundImage drawAtPoint:CGPointZero];
    
    // Drop shadow
    CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextSetShadow(context, CGSizeMake(0.0f, -0.5f), 0.0f);
    CGContextSetShadowWithColor(context, CGSizeMake(0.0f, -0.5f), 0.0f, 
                                CGColorCreateCopyWithAlpha([[self class] black], 0.6f));
    
    CGSize adjustedNameSize = [[self class] adjustedSizeForName:self.name];
	[self customLeadingDrawing:self.name 
                      withSize:[[self class] sizeForName:self.name]
                       leading:[[self class] nameLeading:self.name]];
    
    UIColor *textColor = [UIColor whiteColor];
    [textColor set];
    CGSize categoriesSize = [[self class] sizeForCategories:self.categories];
    [self.categories drawInRect:CGRectMake(kPadding, adjustedNameSize.height, 
                                           categoriesSize.width, categoriesSize.height) 
                 withFont:[[self class] categoriesFont] 
            lineBreakMode:kInfoLinebreak];
    
    textColor = [UIColor whiteColor];
    [textColor set];
    CGSize distancePriceSize = [[self class] sizeForDistancePrice:self.distancePrice];
    [self.distancePrice drawInRect:CGRectMake(kPadding, 
                                              adjustedNameSize.height + categoriesSize.height + [[self class] categoriesLeading], 
                                              distancePriceSize.width, distancePriceSize.height) 
                       withFont:[[self class] distancePriceFont] 
                  lineBreakMode:kInfoLinebreak];
    
    textColor = [UIColor whiteColor];
    [textColor set];
    CGSize blurbSize = [[self class] sizeForBlurb:self.blurb];
    CGRect blurbRect = CGRectMake(kPadding, 
                                  adjustedNameSize.height + categoriesSize.height + (2 * kPadding),
                                  blurbSize.width, blurbSize.height);
	[self.blurb drawInRect:blurbRect
                  withFont:[[self class] blurbFont]
             lineBreakMode:kBlurbLineBreak];

    
    CGSize iconSize = CGSizeMake(62.5f, 62.5f);
    // Old dynamic positioning
    //CGRect iconRect = CGRectMake(kWidth - kPadding - iconSize.width,
    //                             nameSize.height + categoriesSize.height + kPadding,
    //                             iconSize.width, iconSize.height);
    // New static positioning
    CGRect iconRect = CGRectMake(kWidth - kPadding - iconSize.width, 
                                 kHeight - kPadding - iconSize.height, 
                                 iconSize.width, iconSize.height);
    [self.icon drawInRect:iconRect];
}


@end
