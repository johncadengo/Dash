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
    return [UIFont fontWithName:kHelveticaNeueBold size:18.0f];
}

+ (UIFont *)categoriesFont
{
    return [UIFont fontWithName:kHelveticaNeueBold size:10.0f];    
}

+ (UIFont *)distancePriceFont
{
    return [UIFont fontWithName:kHelveticaNeueBold size:10.0f];
}

+ (UIFont *)blurbFont
{
    return [UIFont systemFontOfSize:10];
}

+ (CGSize)sizeForName:(NSString *)name
{
    CGFloat maxWidth = kWidth - (2 * kPadding);
	CGSize textSize = [name sizeWithFont:[self nameFont] 
                                forWidth:maxWidth 
                           lineBreakMode:kNameLineBreak];
    
    return textSize;
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
    self.distancePrice = [NSString stringWithFormat:@"%.1f  %@", distance, place.price];
    self.blurb = [NSString stringWithFormat:@""];
    
    // Draw self
    [self setNeedsDisplay];
}

#pragma mark - Draw

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
    
    
    UIColor * textColor = [UIColor whiteColor];	
	[textColor set];
	CGSize nameSize = [[self class] sizeForName:self.name];
	[self.name drawInRect:CGRectMake(kPadding, kPadding,
                                     nameSize.width, nameSize.height)
                 withFont:[[self class] nameFont]
            lineBreakMode:kNameLineBreak];
    
    textColor = [UIColor whiteColor];
    [textColor set];
    CGSize categoriesSize = [[self class] sizeForCategories:self.categories];
    [self.categories drawInRect:CGRectMake(kPadding, 
                                           nameSize.height + kPadding, 
                                           categoriesSize.width, categoriesSize.height) 
                 withFont:[[self class] categoriesFont] 
            lineBreakMode:kInfoLinebreak];
    
    textColor = [UIColor whiteColor];
    [textColor set];
    
    CGSize blurbSize = [[self class] sizeForBlurb:self.blurb];
    CGRect blurbRect = CGRectMake(kPadding, 
                                  nameSize.height + categoriesSize.height + (2 * kPadding),
                                  blurbSize.width, blurbSize.height);
	[self.blurb drawInRect:blurbRect
                  withFont:[[self class] blurbFont]
             lineBreakMode:kBlurbLineBreak];

}


@end
