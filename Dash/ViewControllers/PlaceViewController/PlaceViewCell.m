//
//  PlaceViewCell.m
//  Dash
//
//  Created by John Cadengo on 11/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceViewCell.h"

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
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier cellType:(PlaceViewCellType)cellType
{
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setWithPlace:(Place *)place
{
    
}

@end
