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
#import "Like.h"
#import "Like+Helper.h"
#import "Person.h"
#import "Person+Helper.h"
#import "Constants.h"

@implementation HighlightViewCell

@synthesize type = _type;
@synthesize name = _name;
@synthesize author = _author;
@synthesize backgroundImage = _backgroundImage;
@synthesize heart = _heart;
@synthesize likeCount = _likeCount;

static const CGFloat kTopHeight = 43.5f;
static const CGFloat kMiddleHeight = 40.0f;
static const CGFloat kBottomHeight = 50.0f;

static const CGFloat kWidth = 320.0f;
static const CGFloat kLineLength = 284.0f;

static const CGFloat kTitleHeight = 15.0f;
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
        /*
        case HighlightViewCellTypeLast:
            height = kBottomHeight;
            break;
         */
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

+ (UIFont *)likeCountFont
{
    return [UIFont fontWithName:kHelveticaNeueBold size:15.0f];
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
        // Now initiate the type and save the row
        self.type = type;
        
        CGFloat offset = (self.type == HighlightViewCellTypeFirst) ? kTopYOffset + kTitleHeight : kYOffset;
        self.heart = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.heart setImage:[UIImage imageNamed:@"Heart-Gray.png"] forState:UIControlStateNormal];
        [self.heart setImage:[UIImage imageNamed:@"Heart-Red.png"] forState:UIControlStateSelected];
        [self.heart setFrame:CGRectMake(257.0f - 10.0f, offset - 10.0f, 25.0f + 20.0f, 25.0f + 20.0f)];
        [self.heart setImageEdgeInsets:UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f)];
        [self addSubview:self.heart];
        
        [self.heart addTarget:self action:@selector(fakeIncrement:) forControlEvents:UIControlEventTouchUpInside];
        
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
    _type = type;
    
    // Adjust the background bubble accordingly
    NSString *imageName;
    switch (_type) {
        case HighlightViewCellTypeFirst:
            imageName = @"HighlightTop.png";
            break;
        /*
         case HighlightViewCellTypeLast:
            imageName = @"HighlightBottom.png";
            break;
         */
        default:
            imageName = @"HighlightMiddle.png";
            break;
    }
    
    self.backgroundImage = [UIImage imageNamed:imageName];
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
    
    // Two digit max
    NSInteger n = [highlight.likes count];
    self.likeCount = [NSString stringWithFormat:@"%d",(n <= 99) ? n : 99];
    
    // And draw them
    [self setNeedsDisplay];
}

- (void)fakeIncrement:(id)sender
{
    // TODO: The BOOL is backwards because of the order that self.heart toggles its selection...
    self.likeCount = [NSString stringWithFormat:@"%d", (self.heart.selected) ? 0 : 1];
    
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
        [UIColorFromRGB(kPlaceTitlesTextColor) set];
        [kHighlightTitle drawAtPoint:CGPointMake(7.5f, 0.0f) withFont:[[self class] titleFont]];
    }
    else {
        // Draw background
        bgOrigin = CGPointZero;
        [self.backgroundImage drawAtPoint:bgOrigin];
    }
    
    
    // Draw name
    CGFloat yOffset = (self.type == HighlightViewCellTypeFirst) ? kTopYOffset + kTitleHeight : kYOffset;
    
    [UIColorFromRGB(kHighlightTextColor) set];
    [self.name drawAtPoint:CGPointMake(17.0f, yOffset) withFont:[[self class] nameFont]];
    
    // Draw author
    [UIColorFromRGB(kHighlightAuthorColor) set];
    [self.author drawAtPoint:CGPointMake(18.0f, yOffset + 17.0f) withFont:[[self class] authorFont]];
    
    // Draw like count
    [UIColorFromRGB(kHighlightLikesColor) set];
    [self.likeCount drawAtPoint:CGPointMake(257.0f + 30.0f, yOffset + 2.5f) withFont:[[self class] likeCountFont]];
    
    // Draw line at bottom, as long as we aren't the last cell
    if (YES) { //self.type != HighlightViewCellTypeLast) {
        CGPoint origin = CGPointMake((kWidth - kLineLength) / 2.0f, [[self class] heightForType:self.type]);
        [self drawHorizontalLineStartingAt:origin withLength:kLineLength];
    }
}

@end
