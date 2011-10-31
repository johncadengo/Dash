//
//  FeedCell.h
//  Dash
//
//  Created by John Cadengo on 10/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TISwipeableTableView.h"

@class FeedCell;

@protocol FeedCellDelegate <NSObject>
- (void)cellBackButtonWasTapped:(FeedCell *)cell;
@end

@interface FeedCell : TISwipeableTableViewCell {
	
	__weak id <FeedCellDelegate> delegate;
	NSString * text;
}

@property (nonatomic, weak) id <FeedCellDelegate> delegate;
@property (nonatomic, copy) NSString * text;

- (void)drawShadowsWithHeight:(CGFloat)shadowHeight opacity:(CGFloat)opacity InRect:(CGRect)rect forContext:(CGContextRef)context;

@end