//
//  FeedCell.h
//  Dash
//
//  Created by John Cadengo on 10/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TISwipeableTableView.h"

/** An ActionViewCell can come in different varities. 
    Setting it to each one will enable/disable selecting,
    and/or change the appearance of the ActionViewCell
 */
typedef enum {
    ActionViewCellTypeHeader = 0,
    ActionViewCellTypeFeedItem = 1,
    ActionViewCellTypeFootprint = 2,
    kNumActionViewCellTypes = 3
} ActionViewCellType;

@class ActionViewCell;
@class Action;

@protocol ActionVIewCellDelegate <NSObject>
- (void)cellBackButtonWasTapped:(ActionViewCell *)cell;
@end

@interface ActionViewCell : TISwipeableTableViewCell

@property (nonatomic, weak) id <ActionVIewCellDelegate> delegate;

// Model
@property (nonatomic) ActionViewCellType cellType;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *blurb;
@property (nonatomic, strong) NSString *timestamp;
@property (nonatomic, strong) UIImage *image;

// Methods

/** Class method to determine the dyanmic row height of an action cell view
 */
+ (CGFloat)heightForAction:(Action *)action withCellType:(ActionViewCellType)cellType;

+ (UIFont *)nameFont;
+ (UIFont *)blurbFont;
+ (UIFont *)timestampFont;
+ (CGSize)textSizeForName:(NSString *)name;
+ (CGSize)textSizeForBlurb:(NSString *)blurb;
+ (CGSize)textSizeForTimestamp:(NSString *)timestamp;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(ActionViewCellType) cellType;

- (void)setWithAction:(Action*)action;

- (void)drawShadowsWithHeight:(CGFloat)shadowHeight opacity:(CGFloat)opacity InRect:(CGRect)rect forContext:(CGContextRef)context;

@end