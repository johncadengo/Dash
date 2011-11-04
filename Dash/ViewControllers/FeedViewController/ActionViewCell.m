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

@interface TISwipeableTableViewCell ()
- (void)initialSetup;
@end

@implementation ActionViewCell
@synthesize cellType = _cellType;
@synthesize delegate;
@synthesize name;
@synthesize blurb;
@synthesize timestamp;
@synthesize image;

#pragma mark - Some UI constants

static CGFloat kWindowWidth = 320.0f;
static CGFloat kDefaultHeight = 100.0f;
static CGFloat kPadding = 10.0f;
static CGFloat kPicWidth = 57.0f;

#pragma mark - Class methods

+ (CGFloat)heightForBlurb:(NSString *)blurb withCellType:(ActionViewCellType)cellType
{
    CGSize textSize = [self textSizeForBlurb:blurb];
    CGFloat height = textSize.height;
    
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
    CGFloat maxWidth = kWindowWidth - 68.0;
	CGSize textSize = [name sizeWithFont:[self nameFont] 
                                     forWidth:maxWidth 
                                lineBreakMode:UILineBreakModeTailTruncation];
    
    return textSize;

}

+ (CGSize)textSizeForBlurb:(NSString *)blurb
{
    CGFloat maxWidth = kWindowWidth - 68.0;
	CGSize textSize = [blurb sizeWithFont:[self blurbFont] 
                                     forWidth:maxWidth 
                                lineBreakMode:UILineBreakModeWordWrap];
    
    return textSize;
    
}

+ (CGSize)textSizeForTimestamp:(NSString *)timestamp
{
    CGFloat maxWidth = kWindowWidth - 68.0;
	CGSize textSize = [timestamp sizeWithFont:[self timestampFont] 
                                     forWidth:maxWidth 
                                lineBreakMode:UILineBreakModeTailTruncation];
    
    return textSize;
    
}

#pragma mark - Instance methods

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier cellType:kNumActionViewCellTypes];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(ActionViewCellType)cellType
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setCellType:cellType];
    }
	
    return self;
}

/** Need to override this to change "oldstyle" private ivar of super class
 */
- (void)initialSetup
{
    //self.selectionStyle = UITableViewCellSelectionStyleNone;
    [super initialSetup];
}

- (void)setCellType:(ActionViewCellType)newCellType
{
    // If the type is invalid, we will set it to the default value: Header
    if (newCellType >= kNumActionViewCellTypes) {
        newCellType = ActionViewCellTypeHeader;
    }

    _cellType = newCellType;
    
    UITableViewCellSelectionStyle selectionStyle;
    bool userInteractionEnabled;
    
    // TODO: This all works as long as NONE is paired with NO.
    switch (_cellType) {
        case ActionViewCellTypeHeader:
            selectionStyle = UITableViewCellSelectionStyleNone;
            userInteractionEnabled = NO;
            break;
        case ActionViewCellTypeFeedItem:
            selectionStyle = UITableViewCellSelectionStyleBlue;            
            userInteractionEnabled = YES;
            break;
        case ActionViewCellTypeFootprint:
            selectionStyle = UITableViewCellSelectionStyleBlue;            
            userInteractionEnabled = YES;
            break;
        default:
            // Should never happen
            NSAssert(NO, @"Trying to set ActionViewCellType that doesn't exist: %d", _cellType);
            break;
    }
    
    self.selectionStyle = selectionStyle;
    self.userInteractionEnabled = userInteractionEnabled;
}

- (void)setWithAction:(Action*)action
{
    Highlight *highlight = (Highlight*) action;
    self.name = @"Laura Byun";
    self.blurb = [highlight text];
    self.timestamp = @"2 days ago";
    self.image = [UIImage imageNamed:@"icon.png"];
    
    [self setNeedsDisplay];
}

- (void)buttonWasTapped:(UIButton *)button {
	
	if ([delegate respondsToSelector:@selector(cellBackButtonWasTapped:)]){
		[delegate cellBackButtonWasTapped:self];
	}
}

- (void)backViewWillAppear {
	


}

- (void)backViewDidDisappear {
	// Remove any subviews from the backView.
	
	for (UIView * subview in self.backView.subviews){
		[subview removeFromSuperview];
	}
}

- (void)drawContentView:(CGRect)rect {
	
	UIColor * textColour = (self.selected || self.highlighted) ? [UIColor whiteColor] : [UIColor blackColor];	
	[textColour set];
	CGSize nameSize = [[self class] textSizeForName:self.name];
	[self.name drawInRect:CGRectMake(kPicWidth + (kPadding * 2), kPadding,
								nameSize.width, nameSize.height)
			withFont:[[self class] nameFont]];

    CGSize blurbSize = [[self class] textSizeForBlurb:self.blurb];
	[self.blurb drawInRect:CGRectMake(kPicWidth + (kPadding * 2), nameSize.height + kPadding,
                                 blurbSize.width, blurbSize.height)
             withFont:[[self class] blurbFont]];
    
    CGSize timeSize = [[self class] textSizeForTimestamp:self.timestamp];
	[self.timestamp drawInRect:CGRectMake(kWindowWidth - kPadding - timeSize.width, kPadding,
                                 timeSize.width, timeSize.height)
             withFont:[[self class] timestampFont]];
    
    // Let's put an image here
    CGPoint point = CGPointMake(kPadding, kPadding); 
    [self.image drawAtPoint:point];
}

- (void)drawBackView:(CGRect)rect {
	
	[[UIImage imageNamed:@"meshpattern.png"] drawAsPatternInRect:rect];
	[self drawShadowsWithHeight:10 opacity:0.3 InRect:rect forContext:UIGraphicsGetCurrentContext()];
    
    NSString *backViewText = [NSString stringWithFormat:@"buddy"];
    
    UIColor * textColour = (self.selected || self.highlighted) ? [UIColor whiteColor] : [UIColor blackColor];	
	[textColour set];
	
	UIFont * textFont = [UIFont boldSystemFontOfSize:16];
	
	CGSize textSize = [backViewText sizeWithFont:textFont constrainedToSize:rect.size];
	[backViewText drawInRect:CGRectMake((rect.size.width / 2) - (textSize.width / 2), 
                                    (rect.size.height / 2) - (textSize.height / 2),
                                    textSize.width, textSize.height)
                withFont:textFont];
}

- (void)drawShadowsWithHeight:(CGFloat)shadowHeight opacity:(CGFloat)opacity InRect:(CGRect)rect forContext:(CGContextRef)context {
	
	CGColorSpaceRef space = CGBitmapContextGetColorSpace(context);
	
	CGFloat topComponents[8] = {0, 0, 0, opacity, 0, 0, 0, 0};
	CGGradientRef topGradient = CGGradientCreateWithColorComponents(space, topComponents, nil, 2);
	CGPoint finishTop = CGPointMake(rect.origin.x, rect.origin.y + shadowHeight);
	CGContextDrawLinearGradient(context, topGradient, rect.origin, finishTop, kCGGradientDrawsAfterEndLocation);
	
	CGFloat bottomComponents[8] = {0, 0, 0, 0, 0, 0, 0, opacity};
	CGGradientRef bottomGradient = CGGradientCreateWithColorComponents(space, bottomComponents, nil, 2);
	CGPoint startBottom = CGPointMake(rect.origin.x, rect.size.height - shadowHeight);
	CGPoint finishBottom = CGPointMake(rect.origin.x, rect.size.height);
	CGContextDrawLinearGradient(context, bottomGradient, startBottom, finishBottom, kCGGradientDrawsAfterEndLocation);
	
	CGGradientRelease(topGradient);
	CGGradientRelease(bottomGradient);
}

@end
