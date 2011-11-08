//
//  FeedbackActivityCell.h
//  Dash
//
//  Created by John Cadengo on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Action;

@interface FeedbackActivityCell : UITableViewCell

@property (nonatomic, strong) NSString *activity;

+ (UIFont *)activityFont;
+ (CGFloat)heightForAction:(Action *)action;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier action:(Action *)action;
- (void)setWithAction:(Action *)action;

@end
