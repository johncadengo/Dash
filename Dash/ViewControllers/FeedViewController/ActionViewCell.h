//
//  FeedCell.h
//  Dash
//
//  Created by John Cadengo on 10/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Action;

@interface ActionViewCell : UITableViewCell

@property (nonatomic, strong) NSString *blurb;
@property (nonatomic, strong) NSString *timestamp;
@property (nonatomic, strong) UIImage *icon;

+ (CGFloat)heightForAction:(Action *)action;

+ (UIFont *)blurbFont;
+ (UIFont *)timestampFont;
+ (CGSize)textSizeForBlurb:(NSString *)blurb;
+ (CGSize)textSizeForTimestamp:(NSString *)timestamp;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setWithAction:(Action*)action;

@end