//
//  FeedbackActivityCell.m
//  Dash
//
//  Created by John Cadengo on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FeedbackActivityCell.h"
#import "Action.h"
#import "Action+Helper.h"

@implementation FeedbackActivityCell

@synthesize activity;

#pragma mark - UI Constants

static CGFloat kPaddingTop = 2.5f;
static CGFloat kPaddingBottom = 2.5f;
static CGFloat kPaddingLeft = 10.0f;
static CGFloat kWindowWidth = 320.0f;

#pragma mark - Class methods

+ (UIFont *)activityFont
{
    return [UIFont systemFontOfSize:11.0f];
}

+ (CGFloat)heightForAction:(Action *)action
{
    NSString *activity = [NSString stringWithFormat:@"1 Like"];
    
    CGFloat maxWidth = kWindowWidth;
    CGSize textSize = [activity sizeWithFont:[self activityFont] 
                                    forWidth:maxWidth 
                               lineBreakMode:UILineBreakModeHeadTruncation];
    
    return textSize.height + kPaddingTop + kPaddingBottom;
}

#pragma mark - Instance methods

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier action:nil];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier action:(Action *)action
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // This cell should not be selectable.
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self setWithAction:action];
    }
    return self;    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setWithAction:(Action *)action
{
    // TODO: Actually look at the action
    self.activity = [NSString stringWithFormat:@"2 comments, 1 like"];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGPoint origin = CGPointMake(kPaddingLeft, kPaddingTop);
    [[UIColor grayColor] set];
    [self.activity drawAtPoint:origin withFont:[[self class] activityFont]];
    

}

@end
