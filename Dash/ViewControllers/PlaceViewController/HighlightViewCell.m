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

static const CGFloat topHeight = 45.0f;
static const CGFloat middleHeight = 40.0f;
static const CGFloat bottomHeight = 50.0f;

+ (CGFloat) heightForType:(HighlightViewCellType) type
{
    CGFloat height;
    
    switch (type) {
        case HighlightViewCellTypeFirst:
            height = topHeight;
            break;
        case HighlightViewCellTypeLast:
            height = bottomHeight;
            break;
        default:
            height = middleHeight;
            break;
    }
    
    return height;
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
    self.author = [NSString stringWithFormat:@"%@", highlight.author.name];
    
    // And draw them
    [self setNeedsDisplay];
}

#pragma mark - Draw

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // Draw background
    [self.backgroundImage drawAtPoint:CGPointZero];
    
    // Draw text
    UIFont *font = [UIFont systemFontOfSize:14.0f];
    UIColor *textColor = UIColorFromRGB(kHighlightTextColor);
    [textColor set];
    
    [self.name drawAtPoint:CGPointMake(15.0f, 10.0f) withFont:font];
}

@end
