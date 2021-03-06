//
//  BadgesViewCell.h
//  Dash
//
//  Created by John Cadengo on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BadgesViewCell : UITableViewCell

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *badges;
@property (nonatomic, strong) NSMutableArray *badgesViews;

+ (CGFloat)height;

- (CGRect)frameForBadgeIndex:(NSInteger)n;

@end
