//
//  MoreInfoViewCell.m
//  Dash
//
//  Created by John Cadengo on 11/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MoreInfoViewCell.h"

@implementation MoreInfoViewCell

@synthesize delegate = _delegate;

#pragma mark - UI Constants

//static CGFloat kWindowWidth = 320.0f;
//static CGFloat kPadding = 5.0f;

#pragma mark - Class methods

+ (CGFloat)height
{
    return 40.0f;
}

#pragma mark - Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // This cell should not be selectable.
        //self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}


#pragma mark - Swipeable cell


- (void)buttonWasTapped:(UIButton *)button 
{

}

- (void)backViewWillAppear 
{
	
    
    
}

- (void)backViewDidDisappear 
{
	// Remove any subviews from the backView.
	
	for (UIView * subview in self.backView.subviews){
		[subview removeFromSuperview];
	}
}

- (void)drawContentView:(CGRect)rect 
{	
    // Draw the "More Info"
    UIFont *font = [UIFont systemFontOfSize:16];
    NSString *moreInfo = [NSString stringWithFormat:@"More Information"];
    CGSize size = [moreInfo sizeWithFont:font];
    CGPoint point = CGPointMake((rect.size.width / 2.0f) - (size.width / 2.0f),
                                (rect.size.height / 2.0f) - (size.height / 2.0f));
    [moreInfo drawAtPoint:point withFont:font];
}

- (void)drawBackView:(CGRect)rect {
	
	[[UIImage imageNamed:@"meshpattern.png"] drawAsPatternInRect:rect];
    
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

@end
