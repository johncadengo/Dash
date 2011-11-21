//
//  PlaceViewCell.m
//  Dash
//
//  Created by John Cadengo on 11/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceViewCell.h"
#import "Place.h"

@implementation PlaceViewCell

@synthesize delegate = _delegate;
@synthesize name = _name;
@synthesize address = _address;
@synthesize cellType = _cellType;

#pragma mark - Some UI Constants

static CGFloat kWindowWidth = 320.0f;
static CGFloat kPadding = 5.0f;

static CGFloat kMaxAddressHeight = 1000.0f;

static UILineBreakMode kNameLineBreak = UILineBreakModeHeadTruncation;
static UILineBreakMode kAddressLineBreak = UILineBreakModeWordWrap;

#pragma mark - Class methods

+ (CGSize)sizeForPlace:(Place *)place withCellType:(PlaceViewCellType)cellType
{
    
}

+ (UIFont *)nameFont
{
    return [UIFont boldSystemFontOfSize:16];
}

+ (UIFont *)addressFont
{
    return [UIFont systemFontOfSize:14];
}

+ (CGSize)textSizeForName:(NSString *)name
{
    // TODO: Account for the little icons
    CGFloat maxWidth = kWindowWidth - (2 * kPadding);
    CGSize textSize = [name sizeWithFont:[self nameFont] 
                                forWidth:maxWidth 
                           lineBreakMode:kNameLineBreak];
    
    return textSize;
}

+ (CGSize)textSizeForAddress:(NSString *)address
{
    // TODO: Account for the little icons
    CGFloat maxWidth = kWindowWidth - (2 * kPadding);
    CGSize maxSize = CGSizeMake(maxWidth, kMaxAddressHeight);
    CGSize textSize = [address sizeWithFont:[self addressFont] 
                          constrainedToSize:maxSize
                              lineBreakMode:kAddressLineBreak];
    
    return textSize;
}

#pragma mark - Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(PlaceViewCellType) cellType
{
    
}

- (void)setCellType:(PlaceViewCellType)cellType
{
    
}

- (void)setWithPlace:(Place *)place
{
    
}

@end
