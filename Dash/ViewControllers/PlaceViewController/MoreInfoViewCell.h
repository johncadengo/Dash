//
//  MoreInfoViewCell.h
//  Dash
//
//  Created by John Cadengo on 11/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

@class Place;

@interface MoreInfoViewCell : UITableViewCell <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIButton *mapButton;
@property (nonatomic, strong) UIButton *callButton;
@property (nonatomic, strong) UIButton *hoursButton;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *hoursLabel;

+ (CGFloat)height;

- (void)setWithPlace:(Place *)place;
- (void)call:(id)sender;

@end