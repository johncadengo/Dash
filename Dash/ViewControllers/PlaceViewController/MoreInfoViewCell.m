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
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MoreInformationButton.png"]];
        [self setBackgroundView:imageView];
    }
    
    return self;
}


#pragma mark - 


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}

@end
