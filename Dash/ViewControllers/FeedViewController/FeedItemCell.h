//
//  FeedCell.h
//  Dash
//
//  Created by John Cadengo on 10/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TISwipeableTableView.h"

@class FeedItemCell;
@class Action;

@protocol FeedCellDelegate <NSObject>
- (void)cellBackButtonWasTapped:(FeedItemCell *)cell;
@end

@interface FeedItemCell : TISwipeableTableViewCell

@property (nonatomic, weak) id <FeedCellDelegate> delegate;

// Model
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *blurb;
@property (nonatomic, strong) NSString *relativeTimestamp;
@property (nonatomic, strong) UIImageView *imageView;

// Methods
- (void)setWithAction:(Action*)action;

- (void)drawShadowsWithHeight:(CGFloat)shadowHeight opacity:(CGFloat)opacity InRect:(CGRect)rect forContext:(CGContextRef)context;

@end