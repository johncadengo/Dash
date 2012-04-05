//
//  TitleViewCell.h
//  Dash
//
//  Created by John Cadengo on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleViewCell : UITableViewCell

@property (nonatomic, strong) NSString *title;

+ (UIFont *)font;
+ (CGFloat)height;

@end
