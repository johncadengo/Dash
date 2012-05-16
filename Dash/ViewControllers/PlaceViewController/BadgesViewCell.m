//
//  BadgesViewCell.m
//  Dash
//
//  Created by John Cadengo on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BadgesViewCell.h"
#import "BadgeSquareView.h"
#import "Badge.h"

@implementation BadgesViewCell

@synthesize scrollView = _scrollView;
@synthesize badges = _badges;
@synthesize badgesViews = _badgesViews;

+ (CGFloat)height 
{
    return 164.0f / 2.0f;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Scroll view
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10.0f, (([[self class] height] - BadgeSquareView.size.height) / 2.0f) - 2.0f, 300.0f, BadgeSquareView.size.height)];
        [self.scrollView setScrollEnabled:YES];
        [self.scrollView setPagingEnabled:YES];
        [self addSubview:self.scrollView];
        
        [self setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BadgeBubble.png"]]];
        
        self.badgesViews = [[NSMutableArray alloc] initWithCapacity:4];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGRect)frameForBadgeIndex:(NSInteger)n
{
    CGRect frame = CGRectMake(BadgeSquareView.size.width * n, 0.0f, BadgeSquareView.size.width, BadgeSquareView.size.height);
    return frame;
}

- (void)setBadges:(NSArray *)badges
{
    // Save the badges
    _badges = [badges sortedArrayUsingSelector:@selector(compare:)];
    
    // Clear out the old badges
    [self.badgesViews removeAllObjects];
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    // Now populate the new badges
    for (Badge *badge in _badges) {
        BadgeSquareView *squareView = [[BadgeSquareView alloc] initWithFrame:[self frameForBadgeIndex:[self.badgesViews count]]];
        [squareView setWithBadge:badge];
        [self.badgesViews addObject:squareView];
        [self.scrollView addSubview:squareView];
    }
    
    // Now adjust content size of the scroll view based on how many badges we have
    NSInteger pages = ceil((BadgeSquareView.size.width * [self.badgesViews count]) / 300.0f);
    [self.scrollView setContentSize:CGSizeMake(300.0f * pages, BadgeSquareView.size.height)];
}

@end
