//
//  MoreInfoViewCell.m
//  Dash
//
//  Created by John Cadengo on 11/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MoreInfoViewCell.h"

@implementation MoreInfoViewCell

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
        
    }
    
    return self;
}


#pragma mark - 


- (void)drawRect:(CGRect)rect
{
    // Draw the "More Info"
    UIFont *font = [UIFont systemFontOfSize:16];
    NSString *moreInfo = [NSString stringWithFormat:@"More Information"];
    CGSize size = [moreInfo sizeWithFont:font];
    CGPoint point = CGPointMake((rect.size.width / 2.0f) - (size.width / 2.0f),
                                (rect.size.height / 2.0f) - (size.height / 2.0f));
    [moreInfo drawAtPoint:point withFont:font];
}

@end
