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
            imageName = @"";
            break;
        case HighlightViewCellTypeLast:
            
            break;
        default:
            
            break;
    }
    
    // Now save the type
    _type = type;
}

- (void)setWithHighlight:(Highlight *)highlight
{
    // Set our properties
    self.name = [NSString stringWithFormat:@"%@", highlight.text];
    self.author = [NSString stringWithFormat:@"%@", highlight.author.name];
    
    // And draw them
    [self setNeedsDisplay];
}

#pragma mark - Draw

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    UIFont *font = [UIFont systemFontOfSize:14.0f];
    UIColor *textColor = UIColorFromRGB(kHighlightTextColor);
    [textColor set];
    
    [self.name drawAtPoint:CGPointMake(0.0f, 0.0f) withFont:font];
}

@end
