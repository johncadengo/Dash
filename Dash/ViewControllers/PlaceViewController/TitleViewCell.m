//
//  TitleViewCell.m
//  Dash
//
//  Created by John Cadengo on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TitleViewCell.h"
#import "Constants.h"

@implementation TitleViewCell

@synthesize title = _title;

+ (UIFont *)font
{
    return [UIFont fontWithName:kPlutoBold size:14.0f];
}

+ (CGFloat)height
{
    return [@"Highlights" sizeWithFont:[self font]].height - 4.0f; // Negative leading..
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.title = @"";
        
        [self setClipsToBounds:NO];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Title setter
- (void)setTitle:(NSString *)title
{
    _title = [NSString stringWithFormat:@"%@", title];
    
    // Make sure to refresh view
    [self setNeedsDisplay];
}

#pragma mark - Draw

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [UIColorFromRGB(kPlaceTitlesTextColor) set];
    [self.title drawAtPoint:CGPointMake(7.5f, 0.0f) withFont:[[self class] font]];
}

@end
