//
//  PlaceSquareViewCell.m
//  Dash
//
//  Created by John Cadengo on 12/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceSquareViewCell.h"
#import "Place.h"

@implementation PlaceSquareViewCell

@synthesize name = _name;
@synthesize info = _info;
@synthesize blurb = _blurb;
@synthesize badges = _badges;
@synthesize icon = _icon;

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
    return [UIFont systemFontOfSize:16];
}

+ (UIFont *)infoFont
{
    return [UIFont systemFontOfSize:12];
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

+ (CGSize)sizeForInfo:(NSString *)info
{
    CGFloat maxWidth = kWidth - (2 * kPadding);
	CGSize textSize = [info sizeWithFont:[self infoFont] 
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

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Set

- (void)setWithPlace:(Place *)place
{
    // Set all our instance variables
    self.name = [place name];
    self.info = [NSString stringWithFormat:@"%@", [place price]];
    self.blurb = [NSString stringWithFormat:@"Love this place!!"];
    
    // Draw self
    [self setNeedsDisplay];
}

#pragma mark - Draw

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    

}


@end
