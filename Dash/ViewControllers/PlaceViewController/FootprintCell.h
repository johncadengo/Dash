//
//  FootprintCell.h
//  Dash
//
//  Created by John Cadengo on 6/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSAttributedString+Attributes.h"
#import "OHAttributedLabel.h"
#import "EGOImageButton.h"

typedef enum {
    FootprintCellTypeFirst = 0,
    FootprintCellTypeMiddle = 1,
    FootprintCellTypeLast = 2,
    FootprintCellTypeOnly = 3,
} FootprintCellType;

@class NewsItem;

@interface FootprintCell : UITableViewCell <EGOImageButtonDelegate>

@property (nonatomic, strong) OHAttributedLabel *blurb;
@property (nonatomic, strong) NSString *timestamp;
@property (nonatomic, strong) EGOImageButton *icon;
@property (nonatomic) FootprintCellType type;
@property (nonatomic, strong) UIImage *backgroundImage;

+ (CGFloat)heightForType:(FootprintCellType)type;

+ (UIFont *)blurbFont;
+ (UIFont *)timestampFont;
+ (CGSize)textSizeForBlurb:(NewsItem *)newsItem;
+ (CGSize)textSizeForTimestamp:(NSString *)timestamp;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(FootprintCellType)type;
- (void)setWithNewsItem:(NewsItem *)newsItem;
- (void)drawHorizontalLineStartingAt:(CGPoint)origin withLength:(CGFloat)length;



@end
