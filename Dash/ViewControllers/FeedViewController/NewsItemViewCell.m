//
//  FeedCell.m
//  Dash
//
//  Created by John Cadengo on 10/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NewsItemViewCell.h"
#import "NewsItem.h"
#import "NewsItem+Helper.h"
#import "NSArray+Helpers.h"
#import "NSString+RandomStrings.h"
#import "UIImage+ProportionalFill.h"
#import "Constants.h"
#import "Person.h"
#import "Person+Helper.h"
#import "Place.h"
#import "Place+Helper.h"

@implementation NewsItemViewCell

@synthesize blurb = _blurb;
@synthesize timestamp = _timestamp;
@synthesize icon = _icon;

#pragma mark - Some UI constants

static CGFloat kWindowWidth = 320.0f;
static CGFloat kLeftRightMargin = 18.0f;
static CGFloat kPadding = 5.0f;
static CGFloat kPicWidth = 50.0f;
static CGFloat kLineLength = 284.0f;
static CGFloat kLineHeight = 4.0f;

/** Should never get THIS big.. Just wanted to leave room
 */
static CGFloat kMaxBlurbHeight = 1000.0f;
static CGFloat kBlurbFontSize = 14.0f;

static UILineBreakMode kBlurbLineBreak = UILineBreakModeWordWrap;
static UILineBreakMode kTimestampLineBreak = UILineBreakModeTailTruncation;


#pragma mark - Class methods

+ (CGFloat)heightForNewsItem:(NewsItem *)newsItem;
{
    CGSize blurbSize = [self textSizeForBlurb:newsItem];
    CGSize timestampSize = [self textSizeForTimestamp:@"My"];
    
    CGFloat textHeight = kPadding + blurbSize.height + kPadding + 
                            timestampSize.height + kPadding + kLineHeight;
    CGFloat iconHeight = 10.0f + kPicWidth + kPadding + kLineHeight;
    ;
    return MAX(iconHeight, textHeight);
}

+ (UIFont *)blurbFont
{
    return [UIFont systemFontOfSize:kBlurbFontSize];
}

+ (UIFont *)timestampFont
{
    return [UIFont systemFontOfSize:10.0f];
}

+ (CGSize)textSizeForBlurb:(NewsItem *)newsItem
{
    /*
    CGFloat maxWidth = kWindowWidth - kPicWidth - (2 * kLeftRightMargin) - (2 * kPadding);
    CGSize maxSize = CGSizeMake(maxWidth, kMaxBlurbHeight);
	CGSize textSize = [blurb sizeWithFont:[self blurbFont] 
                        constrainedToSize:maxSize
                            lineBreakMode:kBlurbLineBreak];
    
    return textSize;
    */
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:newsItem.blurb];
    [attrStr setFont:[self.class blurbFont]];
    [attrStr setTextColor:UIColorFromRGB(kFeedBlurbColor)];
    
    // Now we want to bold the person's name and the place's name
    [attrStr setFont:[UIFont fontWithName:kHelveticaNeueBold size:kBlurbFontSize] 
               range:[newsItem.blurb rangeOfString:newsItem.author.name]];
    [attrStr setFont:[UIFont fontWithName:kHelveticaNeueBold size:kBlurbFontSize] 
               range:[newsItem.blurb rangeOfString:newsItem.place.name]];
    
    // Now connect the attributed string to our OHAttributedLabel
    CGFloat maxWidth = kWindowWidth - kPicWidth - (2 * kLeftRightMargin) - (2 * kPadding);
    CGSize maxSize = CGSizeMake(maxWidth, kMaxBlurbHeight);
    return [attrStr sizeConstrainedToSize:maxSize];
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
        self.icon = [[EGOImageView alloc] initWithPlaceholderImage:[[UIImage imageNamed:@"defaultProfile.jpg"] imageCroppedToFitSize:CGSizeMake(kPicWidth, kPicWidth)] delegate:self];
        self.icon.frame = CGRectMake(kLeftRightMargin, 10.0f, kPicWidth, kPicWidth);
        [self addSubview:self.icon];
        
        self.blurb = [[OHAttributedLabel alloc] initWithFrame:CGRectZero];
        [self.blurb setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.blurb];
    }
	
    return self;
}

- (void)setWithNewsItem:(NewsItem *)newsItem;
{
    // Let's emphasize the person and place in our attributed label
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:newsItem.blurb];
    [attrStr setFont:[self.class blurbFont]];
    [attrStr setTextColor:UIColorFromRGB(kFeedBlurbColor)];
    
    // Now we want to bold the person's name and the place's name
    [attrStr setFont:[UIFont fontWithName:kHelveticaNeueBold size:kBlurbFontSize] 
               range:[newsItem.blurb rangeOfString:newsItem.author.name]];
    [attrStr setFont:[UIFont fontWithName:kHelveticaNeueBold size:kBlurbFontSize] 
               range:[newsItem.blurb rangeOfString:newsItem.place.name]];
    
    // Now connect the attributed string to our OHAttributedLabel
    [self.blurb setAttributedText:attrStr];
    
    self.timestamp = [newsItem relativeTimestamp];
    [self.icon setImageURL:[NSURL URLWithString:[NSString stringWithFormat: @"https://graph.facebook.com/%@/picture", newsItem.author.fb_uid]]];
    
    CGSize blurbSize = [[self class] textSizeForBlurb:newsItem];
    [self.blurb setFrame:CGRectMake(kLeftRightMargin + kPicWidth + kPadding, 10.0f,
                                    blurbSize.width, blurbSize.height)];
    [self.blurb setNeedsDisplay];
    
    
    [self setNeedsDisplay];
}

#pragma mark -

- (void)drawHorizontalLineStartingAt:(CGPoint)origin withLength:(CGFloat)length
{
    // Get the context
    CGContextRef context = UIGraphicsGetCurrentContext();	
    
    // Set the stroke color and width of the pen
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(kFeedLinesColor).CGColor);
    CGContextSetLineWidth(context, 1.0f);
    
	// Set the starting and ending points
	CGContextMoveToPoint(context, origin.x, origin.y);
    CGContextAddLineToPoint(context, origin.x + length, origin.y);
    
	// Draw the line
    CGContextStrokePath(context);    
}

- (void)drawRect:(CGRect)rect
{
    // Draw text
    
    CGSize blurbSize = self.blurb.frame.size;
        
    /*
    [UIColorFromRGB(kFeedBlurbColor) set];
    [self.blurb drawInRect:CGRectMake(kLeftRightMargin + kPicWidth + kPadding, 10.0f,
                                      blurbSize.width, blurbSize.height) 
                  withFont:[[self class] blurbFont] lineBreakMode:kBlurbLineBreak];
    */
    
    [UIColorFromRGB(kFeedTimestampColor) set];
    [self.timestamp drawAtPoint:CGPointMake(kLeftRightMargin + kPicWidth + kPadding, 
                                            blurbSize.height + 10.0f) 
                       withFont:[[self class] timestampFont]];
    
    // Draw line
    CGFloat iconHeight = 10.0f + kPicWidth + kPadding + kLineHeight;
    [self drawHorizontalLineStartingAt:CGPointMake(kLeftRightMargin, 
                                                   MAX(blurbSize.height + 30.0f, iconHeight)) 
                            withLength:kLineLength];
	
}

@end
