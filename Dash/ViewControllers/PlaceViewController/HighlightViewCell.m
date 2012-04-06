//
//  HighlightViewCell.m
//  Dash
//
//  Created by John Cadengo on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HighlightViewCell.h"
#import "Highlight.h"
#import "Highlight+Helper.h"
#import "Person.h"
#import "Person+Helper.h"
#import "Constants.h"

@implementation HighlightViewCell

@synthesize name = _name;
@synthesize author = _author;
@synthesize type = _type;
@synthesize backgroundImage = _backgroundImage;

static const CGFloat kTopHeight = 43.5f;
static const CGFloat kMiddleHeight = 40.0f;
static const CGFloat kBottomHeight = 50.0f;

static const CGFloat kWidth = 320.0f;
static const CGFloat kLineLength = 283.0f;

static const CGFloat kTitleHeight = 14.0f;
static const CGFloat kTopYOffset = 10.0f;
static const CGFloat kYOffset = 5.0f;

extern NSString * const kHighlightTitle;
NSString * const kHighlightTitle = @"Highlights";

+ (CGFloat) heightForType:(HighlightViewCellType) type
{
    CGFloat height;
    
    switch (type) {
        case HighlightViewCellTypeFirst:
            height = kTopHeight + kTitleHeight;
            break;
        case HighlightViewCellTypeLast:
            height = kBottomHeight;
            break;
        default:
            height = kMiddleHeight;
            break;
    }
    
    return height;
}

+ (UIFont *)titleFont
{
    return [UIFont fontWithName:kPlutoBold size:14.0f];
}

+ (UIFont *)nameFont
{
    return [UIFont systemFontOfSize:14.0f];
}

+ (UIFont *)authorFont
{
    return [UIFont systemFontOfSize:10.0f];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(HighlightViewCellType)type
{
    self = [self initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Now initiate the type
        self.type = type;
        
        //[self setBackgroundView:[[UIImageView alloc] initWithImage:self.backgroundImage]];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setType:(HighlightViewCellType)type
{
    // Adjust the background bubble accordingly
    NSString *imageName;
    switch (type) {
        case HighlightViewCellTypeFirst:
            imageName = @"HighlightTop.png";
            break;
        case HighlightViewCellTypeLast:
            imageName = @"HighlightBottom.png";
            break;
        default:
            imageName = @"HighlightMiddle.png";
            break;
    }
    
    self.backgroundImage = [UIImage imageNamed:imageName];
    
    // Now save the type
    _type = type;
}

- (void)setWithHighlight:(Highlight *)highlight
{
    // Set our properties
    self.name = [[NSString stringWithFormat:@"%@", highlight.text] capitalizedString];
    
    // TODO: Test if works with normal users..
    NSString *author;
    if ([highlight.author.name isEqualToString:@"John"])
        author = [NSString stringWithFormat:@"%@", @"The Dash Team"];
    else
        author = [NSString stringWithFormat:@"%@", highlight.author.name];
    self.author = author;
    
    // And draw them
    [self setNeedsDisplay];
}

#pragma mark - Draw

- (void)drawHorizontalLineStartingAt:(CGPoint)origin withLength:(CGFloat)length
{
    // Get the context
    CGContextRef context = UIGraphicsGetCurrentContext();	
    
    // Set the stroke color and width of the pen
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(kHighlightLinesColor).CGColor);
    CGContextSetLineWidth(context, 1.0f);
    
	// Set the starting and ending points
	CGContextMoveToPoint(context, origin.x, origin.y);
    CGContextAddLineToPoint(context, origin.x + length, origin.y);
    
	// Draw the line
    CGContextStrokePath(context);    
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGPoint bgOrigin;
    
    // If we are the first draw title
    if (self.type == HighlightViewCellTypeFirst) {
        // Draw background
        bgOrigin = CGPointMake(0.0f, kTitleHeight);
        [self.backgroundImage drawAtPoint:bgOrigin];
        
        // Draw title
        [kHighlightTitle drawAtPoint:CGPointMake(7.5f, 0.0f) withFont:[[self class] titleFont]];
    }
    else {
        // Draw background
        bgOrigin = CGPointZero;
        [self.backgroundImage drawAtPoint:bgOrigin];
    }
    
    
    // Draw name
    CGFloat yOffset = (self.type == HighlightViewCellTypeFirst) ? kTopYOffset + kTitleHeight : kYOffset;
    
    UIColor *textColor = UIColorFromRGB(kHighlightTextColor);
    [textColor set];
    [self.name drawAtPoint:CGPointMake(15.0f, yOffset) withFont:[[self class] nameFont]];
    
    // Draw author
    textColor = UIColorFromRGB(kHighlightAuthorColor);
    [textColor set];
    [self.author drawAtPoint:CGPointMake(16.0f, yOffset + 17.0f) withFont:[[self class] authorFont]];
    
    // Draw line at bottom, as long as we aren't the last cell
    if (self.type != HighlightViewCellTypeLast) {
        CGPoint origin = CGPointMake((kWidth - kLineLength) / 2.0f, [[self class] heightForType:self.type]);
        [self drawHorizontalLineStartingAt:origin withLength:kLineLength];
    }
}

@end
