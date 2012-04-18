//
//  FeedCell.m
//  Dash
//
//  Created by John Cadengo on 10/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ActionViewCell.h"
#import "Highlight.h"
#import "Highlight+Helper.h"
#import "Person.h"
#import "Person+Helper.h"
#import "NSArray+Helpers.h"
#import "NSString+RandomStrings.h"
#import "UIImage+ProportionalFill.h"
#import "Action.h"
#import "Action+Helper.h"

@implementation ActionViewCell

@synthesize blurb = _blurb;
@synthesize timestamp = _timestamp;
@synthesize icon = _icon;

#pragma mark - Some UI constants

static CGFloat kWindowWidth = 320.0f;
static CGFloat kDefaultHeight = 90.0f;
static CGFloat kPadding = 5.0f;
static CGFloat kPicWidth = 57.0f;
static CGFloat kDetailDisclosureWidth = 30.0f;

/** Should never get THIS big.. Just wanted to leave room
 */
static CGFloat kMaxBlurbHeight = 1000.0f;

static UILineBreakMode kNameLineBreak = UILineBreakModeTailTruncation;
static UILineBreakMode kBlurbLineBreak = UILineBreakModeWordWrap;
static UILineBreakMode kTimestampLineBreak = UILineBreakModeTailTruncation;


#pragma mark - Class methods

+ (CGFloat)heightForAction:(Action *)action
{
    // TODO: Get the actual name and timestamp for calculating size.
    
    //CGSize nameSize = [self textSizeForName:[[action author] name]];
    CGSize nameSize = [self textSizeForName:@"hi"];
    CGSize blurbSize = [self textSizeForBlurb:[action description]];
    //CGSize timestampSize = [self textSizeForTimestamp:[[action timestamp] description]];
    CGSize timestampSize = [self textSizeForTimestamp:@"hi"];
    CGFloat height = kPadding + nameSize.height + kPadding + blurbSize.height + kPadding + timestampSize.height + kPadding;

    return MAX(kDefaultHeight, height);
}

+ (UIFont *)nameFont
{
    return [UIFont boldSystemFontOfSize:16];    
}

+ (UIFont *)blurbFont
{
    return [UIFont systemFontOfSize:14];
}

+ (UIFont *)timestampFont
{
    return [UIFont boldSystemFontOfSize:12];
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
    CGFloat maxWidth = kWindowWidth - kPicWidth - (3 * kPadding) - kDetailDisclosureWidth;
    CGSize maxSize = CGSizeMake(maxWidth, kMaxBlurbHeight);
	CGSize textSize = [blurb sizeWithFont:[self blurbFont] 
                        constrainedToSize:maxSize
                            lineBreakMode:kBlurbLineBreak];
    
    return textSize;
    
}

+ (CGSize)textSizeForTimestamp:(NSString *)timestamp
{
    CGFloat maxWidth = kWindowWidth - kPicWidth - (3 * kPadding);
	CGSize textSize = [timestamp sizeWithFont:[self timestampFont] 
                                     forWidth:maxWidth 
                                lineBreakMode:kTimestampLineBreak];
    
    return textSize;
    
}

#pragma mark - Instance methods

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
    }
	
    return self;
}

- (void)setWithAction:(Action*)action
{
    //NSString *iconPath = [[[action author] profilepic] localpath];
    CGSize size = CGSizeMake(57.0f, 57.0f);
    
    self.blurb = [action description];
    self.timestamp = [action relativeTimestamp];
    //self.icon = [[UIImage imageNamed:iconPath] imageCroppedToFitSize:size];
    
    [self setNeedsDisplay];
}

- (void)drawContentView:(CGRect)rect 
{
    [self.blurb drawAtPoint:CGPointZero withFont:[[self class] blurbFont]];
    [self.timestamp drawAtPoint:CGPointMake(0.0f, 10.0f) withFont:[[self class] timestampFont]];
	
}

@end
