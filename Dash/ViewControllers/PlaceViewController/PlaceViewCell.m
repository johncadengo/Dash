//
//  PlaceViewCell.m
//  Dash
//
//  Created by John Cadengo on 11/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceViewCell.h"
#import "Place.h"

@implementation PlaceViewCell

@synthesize cellType = _cellType;
@synthesize name = _name;
@synthesize blurb = _blurb;
@synthesize image = _image;
@synthesize imageGalleryViewController = _imageGalleryViewController;

#pragma mark - Some UI Constants

static CGFloat kWindowWidth = 320.0f;
static CGFloat kPadding = 5.0f;
static CGFloat kPicWidth = 100.0f;
static CGFloat kMinHeight = 110.0f;

static CGFloat kMaxBlurbHeight = 1000.0f;

static UILineBreakMode kNameLineBreak = UILineBreakModeHeadTruncation;
static UILineBreakMode kBlurbLineBreak = UILineBreakModeWordWrap;

#pragma mark - Class methods for determining the size of UI elements

+ (CGFloat)heightForPlace:(Place *)place withCellType:(PlaceViewCellType)cellType
{
    CGSize nameSize = [self textSizeForName:@"hi"];
    CGSize blurbSize = [self textSizeForBlurb:@"hey hey"];
    
    CGFloat height = kPadding + nameSize.height + kPadding + blurbSize.height + kPadding;
    
    return MAX(height, kMinHeight);
}

+ (UIFont *)nameFont
{
    return [UIFont boldSystemFontOfSize:16];
}

+ (UIFont *)blurbFont
{
    return [UIFont systemFontOfSize:14];
}

+ (CGSize)textSizeForName:(NSString *)name
{
    CGFloat maxWidth = kWindowWidth - kPicWidth - (3 * kPadding);
    CGSize textSize = [name sizeWithFont:[self nameFont]
                                forWidth:maxWidth 
                           lineBreakMode:kNameLineBreak];
    return textSize;
}

+ (CGSize)textSizeForBlurb:(NSString *)blurb
{
    CGFloat maxWidth = kWindowWidth - kPicWidth - (3 * kPadding);
    CGSize maxSize = CGSizeMake(maxWidth, kMaxBlurbHeight);
    CGSize textSize = [blurb sizeWithFont:[self nameFont]
                        constrainedToSize:maxSize
                            lineBreakMode:kBlurbLineBreak];
    return textSize;    
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

- (void)setWithPlace:(Place *)place
{
    // TODO: actually get this data from the place.
    
    self.name = [place name];
    self.blurb = [NSString stringWithFormat:@"Japanese / $$ / 0.3 mi"];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGSize nameSize = [[self class] textSizeForName:self.name];
    [self.name drawInRect:CGRectMake(kPicWidth + (2 * kPadding), kPadding,
                                    nameSize.width, nameSize.height) 
                 withFont:[[self class] nameFont]
            lineBreakMode:kNameLineBreak];
    
    [[UIColor grayColor] set];
    
    CGSize blurbSize = [[self class] textSizeForBlurb:self.blurb];
    CGRect blurbRect = CGRectMake(kPicWidth + (kPadding * 2), 
                                  nameSize.height + (2 * kPadding),
                                  blurbSize.width, blurbSize.height);
	[self.blurb drawInRect:blurbRect
                  withFont:[[self class] blurbFont]
             lineBreakMode:kBlurbLineBreak];
    
    
}

@end
