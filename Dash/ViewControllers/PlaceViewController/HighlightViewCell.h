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
    HighlightViewCellTypeLast = 2
} HighlightViewCellType;

@class Highlight;

@interface HighlightViewCell : UITableViewCell

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *author;
@property (nonatomic) HighlightViewCellType type;
@property (nonatomic, strong) UIImage *backgroundImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(HighlightViewCellType)type;

- (void)setWithHighlight:(Highlight *)highlight;

@end
