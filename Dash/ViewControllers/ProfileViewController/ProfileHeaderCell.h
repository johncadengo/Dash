//
//  ProfileHeaderCell.h
//  Dash
//
//  Created by John Cadengo on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Person;

@interface ProfileHeaderCell : UITableViewCell

@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage *infoBubble;
@property (nonatomic, strong) NSString *numFavorites;
@property (nonatomic, strong) NSString *numFollowers;
@property (nonatomic, strong) NSString *numFollowing;

+ (UIFont *)nameFont;
+ (CGFloat) height;

- (void)setWithPerson:(Person *)person;

@end
