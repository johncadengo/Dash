//
//  PlaceViewCell.m
//  Dash
//
//  Created by John Cadengo on 11/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceViewCell.h"

@implementation PlaceViewCell

@synthesize cellType = _cellType;
@synthesize name = _name;
@synthesize blurb = _blurb;
@synthesize image = _image;
@synthesize imageGalleryViewController = _imageGalleryViewController;

#pragma mark - Class methods for determining the size of UI elements

+ (CGFloat)heightForPlace:(Place *)place withCellType:(PlaceViewCellType)cellType
{
    
}

+ (UIFont *)nameFont
{
    
}

+ (UIFont *)blurbFont
{
    
}

+ (CGSize)textSizeForName:(NSString *)name
{
    
}

+ (CGSize)textSizeForBlurb:(NSString *)blurb
{
    
}

#pragma mark - Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier cellType:(PlaceViewCellType)cellType
{
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setWithPlace:(Place *)place
{
    
}

@end
