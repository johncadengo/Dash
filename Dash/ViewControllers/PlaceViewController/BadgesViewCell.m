//
//  BadgesViewCell.m
//  Dash
//
//  Created by John Cadengo on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BadgesViewCell.h"

@implementation BadgesViewCell

@synthesize scrollView = _scrollView;
@synthesize badges = _badges;

+ (CGFloat)height 
{
    return 100.0f;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Scroll view
        self.scrollView = [[UIScrollView alloc] init];
        [self addSubview:self.scrollView];
        
        [self setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BadgeBubble.png"]]];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
