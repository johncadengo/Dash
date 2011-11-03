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

@implementation ActionViewCell
@synthesize cellType = _cellType;
@synthesize delegate;
@synthesize name;
@synthesize blurb;
@synthesize relativeTimestamp;
@synthesize image;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier actionViewCellType:kNumActionViewCellTypes];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier actionViewCellType:(ActionViewCellType)cellType
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setCellType:cellType];
    }
	
    return self;
}

- (void)setCellType:(ActionViewCellType)cellType
{
    // If the type is invalid, we will set it to the default value: Header
    if (cellType >= kNumActionViewCellTypes) {
        cellType = ActionViewCellTypeHeader;
    }

    _cellType = cellType;
}

- (void)setWithAction:(Action*)action
{
    Highlight *highlight = (Highlight*) action;
    self.blurb = [highlight text];
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
	
	UIFont * textFont = [UIFont boldSystemFontOfSize:16];
	
	CGSize textSize = [blurb sizeWithFont:textFont constrainedToSize:rect.size];
	[blurb drawInRect:CGRectMake((rect.size.width / 2) - (textSize.width / 2), 
								(rect.size.height / 2) - (textSize.height / 2),
								textSize.width, textSize.height)
			withFont:textFont];
    
    // Let's put an image here
    CGFloat imageY = (rect.size.height - self.image.size.height) / 2;
    CGPoint point = CGPointMake(5.0, imageY); 
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
