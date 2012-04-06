//
//  BadgeSquareView.h
//  Dash
//
//  Created by John Cadengo on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Badge;

@interface BadgeSquareView : UIView

@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) NSString *text;

+ (CGSize)size;

- (void)setWithBadge:(Badge *)badge;


@end
