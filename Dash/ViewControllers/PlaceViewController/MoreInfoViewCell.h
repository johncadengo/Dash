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
@property (nonatomic, strong) NSString *addressTitle;
@property (nonatomic, strong) NSString *phoneTitle;
@property (nonatomic, strong) NSString *hoursTitle;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *hoursLabel;

+ (CGFloat)height;

- (void)setWithPlace:(Place *)place;
- (void)call:(id)sender;
- (void)map:(id)sender;
- (NSString *) URLEncodeString:(NSString *) str;

@end