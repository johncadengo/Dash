//
//  HighlightViewCell.h
//  Dash
//
//  Created by John Cadengo on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    HighlightViewCellTypeFirst = 0,
    HighlightViewCellTypeMiddle = 1,
//    HighlightViewCellTypeLast = 2
} HighlightViewCellType;

@class Highlight;

@interface HighlightViewCell : UITableViewCell <UIAlertViewDelegate>

@property (nonatomic) HighlightViewCellType type;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIButton *heart;
@property (nonatomic, strong) NSString *likeCountString;
@property (nonatomic) NSInteger likeCount;
@property (nonatomic, strong) UIAlertView *alertView;

+ (CGFloat) heightForType:(HighlightViewCellType) type;
+ (UIFont *)titleFont;
+ (UIFont *)nameFont;
+ (UIFont *)authorFont;
+ (UIFont *)likeCountFont;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(HighlightViewCellType)type;

- (void)fakeIncrement:(id)sender;
- (void)setWithHighlight:(Highlight *)highlight;
- (void)drawHorizontalLineStartingAt:(CGPoint)origin withLength:(CGFloat)length;

@end
