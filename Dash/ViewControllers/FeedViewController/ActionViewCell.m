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
#import "Constants.h"

@implementation ActionViewCell

@synthesize blurb = _blurb;
@synthesize timestamp = _timestamp;
@synthesize icon = _icon;

#pragma mark - Some UI constants

static CGFloat kWindowWidth = 320.0f;
static CGFloat kDefaultHeight = 90.0f;
static CGFloat kLeftRightMargin = 18.0f;
static CGFloat kPadding = 5.0f;
static CGFloat kPicWidth = 50.0f;
static CGFloat kDetailDisclosureWidth = 30.0f;
static CGFloat kLineLength = 284.0f;

/** Should never get THIS big.. Just wanted to leave room
 */
static CGFloat kMaxBlurbHeight = 1000.0f;

static UILineBreakMode kBlurbLineBreak = UILineBreakModeWordWrap;
static UILineBreakMode kTimestampLineBreak = UILineBreakModeTailTruncation;


#pragma mark - Class methods

+ (CGFloat)heightForAction:(Action *)action
{
    CGSize blurbSize = [self textSizeForBlurb:[action description]];
    //CGSize timestampSize = [self textSizeForTimestamp:[[action timestamp] description]];
    CGSize timestampSize = [self textSizeForTimestamp:@"My"];
    CGFloat height = kPadding + blurbSize.height + kPadding + timestampSize.height + kPadding;

    return MAX(kDefaultHeight, height);
}

+ (UIFont *)blurbFont
{
    return [UIFont fontWithName:kHelveticaNeueBold size:14.0f];
}

+ (UIFont *)timestampFont
{
    return [UIFont systemFontOfSize:10.0f];
}

+ (CGSize)textSizeForBlurb:(NSString *)blurb
{
    CGFloat maxWidth = kWindowWidth - kPicWidth - (2 * kLeftRightMargin) - (2 * kPadding);
    CGSize maxSize = CGSizeMake(maxWidth, kMaxBlurbHeight);
	CGSize textSize = [blurb sizeWithFont:[self blurbFont] 
                        constrainedToSize:maxSize
                            lineBreakMode:kBlurbLineBreak];
    
    return textSize;
    
}

+ (CGSize)textSizeForTimestamp:(NSString *)timestamp
{
    CGFloat maxWidth = kWindowWidth - kPicWidth - (2 * kLeftRightMargin) - (2 * kPadding);
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
    self.blurb = [action description];
    self.timestamp = @"4 mins ago";//[action relativeTimestamp];
    
    // TODO: Get real photo
    self.icon = [[UIImage imageNamed:@"defaultProfile.jpg"] imageCroppedToFitSize:CGSizeMake(kPicWidth, kPicWidth)];
    
    [self setNeedsDisplay];
}

#pragma mark -

- (void)drawHorizontalLineStartingAt:(CGPoint)origin withLength:(CGFloat)length
{
    // Get the context
    CGContextRef context = UIGraphicsGetCurrentContext();	
    
    // Set the stroke color and width of the pen
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(kFilterLinesColor).CGColor);
    CGContextSetLineWidth(context, 1.0f);
    
	// Set the starting and ending points
	CGContextMoveToPoint(context, origin.x, origin.y);
    CGContextAddLineToPoint(context, origin.x + length, origin.y);
    
	// Draw the line
    CGContextStrokePath(context);    
}

- (void)drawRect:(CGRect)rect
{
    // Draw icon
    [self.icon drawAtPoint:CGPointMake(kLeftRightMargin, 10.0f)];
    
    // Draw text
    CGSize blurbSize = [[self class] textSizeForBlurb:self.blurb];
    [UIColorFromRGB(kFeedBlurbColor) set];
    [self.blurb drawInRect:CGRectMake(kLeftRightMargin + kPicWidth + kPadding, 10.0f,
                                      blurbSize.width, blurbSize.height) 
                  withFont:[[self class] blurbFont] lineBreakMode:kBlurbLineBreak];
    
    [UIColorFromRGB(kFeedTimestampColor) set];
    [self.timestamp drawAtPoint:CGPointMake(kLeftRightMargin + kPicWidth + kPadding, 
                                            blurbSize.height + 10.0f) 
                       withFont:[[self class] timestampFont]];
    
    // Draw line
    [self drawHorizontalLineStartingAt:CGPointMake(kLeftRightMargin, 
                                                   blurbSize.height + 30.0f) 
                            withLength:kLineLength];
	
}

@end
