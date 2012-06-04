//
//  FeedCell.h
//  Dash
//
//  Created by John Cadengo on 10/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "NSAttributedString+Attributes.h"
#import "OHAttributedLabel.h"
#import "EGOImageButton.h"

@class NewsItem;

@interface NewsItemViewCell : UITableViewCell <EGOImageButtonDelegate>

@property (nonatomic, strong) OHAttributedLabel *blurb;
@property (nonatomic, strong) NSString *timestamp;
@property (nonatomic, strong) EGOImageButton *icon;

+ (CGFloat)heightForNewsItem:(NewsItem *)newsItem;

+ (UIFont *)blurbFont;
+ (UIFont *)timestampFont;
+ (CGSize)textSizeForBlurb:(NewsItem *)newsItem;
+ (CGSize)textSizeForTimestamp:(NSString *)timestamp;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setWithNewsItem:(NewsItem *)newsItem;
- (void)drawHorizontalLineStartingAt:(CGPoint)origin withLength:(CGFloat)length;

@end